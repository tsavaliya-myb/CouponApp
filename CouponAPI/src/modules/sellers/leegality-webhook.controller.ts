import { Request, Response } from 'express';
import { prisma } from '../../config/db';
import { sendSuccess } from '../../shared/utils/response';
import crypto from 'crypto';
import { env } from '../../config/env';
export class LeegalityWebhookController {

  handleWebhook = async (req: Request, res: Response): Promise<void> => {
    try {
      const payload = req.body;
      // console.log('--- LEEGALITY WEBHOOK RECEIVED ---');
      // console.log(JSON.stringify(payload, null, 2));

      const documentId = payload.documentId;
      const requestData = payload.request || {};
      const signType = requestData.signType;
      const isSigned = requestData.signed === true;
      const providedMac = payload.mac;

      if (!documentId) {
        res.status(400).send('Invalid payload');
        return;
      }

      // Verify MAC if salt is configured
      if (env.LEEGALITY_PRIVATE_SALT && providedMac) {
        const hmac = crypto.createHmac('sha1', env.LEEGALITY_PRIVATE_SALT);
        hmac.update(documentId);
        const computedMac = hmac.digest('hex');

        if (computedMac !== providedMac) {
          console.error('Webhook Error: MAC verification failed.', { computedMac, providedMac });
          res.status(401).send('Unauthorized: MAC mismatch');
          return;
        }
      } else if (env.LEEGALITY_PRIVATE_SALT && !providedMac) {
        console.error('Webhook Error: MAC missing from payload.');
        res.status(401).send('Unauthorized: MAC missing');
        return;
      }

      // Find the agreement
      const agreement = await (prisma as any).sellerAgreement.findUnique({
        where: { leegalityDocumentId: documentId }
      });

      if (!agreement) {
        res.status(404).send('Agreement not found');
        return;
      }

      // Handle events based on signType
      if (isSigned) {
        if (signType === 'AADHAAR') {
          // First signer (Aadhaar) has signed
          await (prisma as any).sellerAgreement.update({
            where: { leegalityDocumentId: documentId },
            data: { status: 'AADHAAR_SIGNED' }
          });
        } else if (signType === 'VIRTUAL_SIGN') {
          // Second signer (Virtual) has signed -> Document is completed
          await (prisma as any).sellerAgreement.update({
            where: { leegalityDocumentId: documentId },
            data: { status: 'COMPLETED' }
          });

          // Also update Seller status to ACTIVE if it was PENDING
          if (agreement.sellerId) {
            await (prisma as any).seller.update({
              where: { id: agreement.sellerId },
              data: { status: 'ACTIVE' }
            });
          }
        }
      }

      sendSuccess(res, { received: true });
    } catch (error) {
      console.error('Webhook Error:', error);
      res.status(500).send('Internal Server Error');
    }
  };
}
