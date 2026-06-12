import { Request, Response } from 'express';
import { prisma } from '../../config/db';
import { sendSuccess } from '../../shared/utils/response';

export class LeegalityWebhookController {
  
  handleWebhook = async (req: Request, res: Response): Promise<void> => {
    try {
      const payload = req.body;
      console.log('--- LEEGALITY WEBHOOK RECEIVED ---');
      console.log(JSON.stringify(payload, null, 2));

      const documentId = payload.documentId;
      const eventName = payload.event; // Typically 'document_completed', 'invitee_signed', etc.

      if (!documentId) {
        res.status(400).send('Invalid payload');
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

      // Handle events
      if (eventName === 'invitee_signed') {
        // One of the signers has signed
        await (prisma as any).sellerAgreement.update({
          where: { leegalityDocumentId: documentId },
          data: { status: 'AADHAAR_SIGNED' } // or intermediate status
        });
      } else if (eventName === 'document_completed') {
        // Both have signed
        const signedDocUrl = payload.documentUrl || ''; // Based on actual Leegality spec
        
        await (prisma as any).sellerAgreement.update({
          where: { leegalityDocumentId: documentId },
          data: { 
            status: 'COMPLETED',
            signedDocumentUrl: signedDocUrl
          }
        });
        
        // Also update Seller status to ACTIVE if it was PENDING
        if (agreement.sellerId) {
            await (prisma as any).seller.update({
                where: { id: agreement.sellerId },
                data: { status: 'ACTIVE' } // Example: mark as active or leave it for manual admin approval as per plan
            });
        }
      }

      sendSuccess(res, { received: true });
    } catch (error) {
      console.error('Webhook Error:', error);
      res.status(500).send('Internal Server Error');
    }
  };
}
