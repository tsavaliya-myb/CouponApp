import { prisma } from '../../config/db';
import { AgreementStatus } from '@prisma/client';

export class LeegalityService {
  private static readonly API_URL = process.env.LEEGALITY_API_URL || 'https://sandbox.leegality.com/api/v3.0/request';
  private static readonly API_KEY = process.env.LEEGALITY_API_KEY || 'your-api-key-here'; // Configure in .env

  /**
   * Initiates the agreement signing process for a seller
   */
  static async initiateAgreement(sellerId: string) {
    const seller = await prisma.seller.findUnique({
      where: { id: sellerId },
      include: { category: true },
    });

    if (!seller) {
      throw new Error('Seller not found');
    }

    // Leegality Payload as provided
    const payload = {
      profileId: 'dxZfDW6',
      file: {
        name: `Seller Agreement - ${seller.businessName}`,
        fields: [
          {
            name: 'le-businessName',
            value: seller.businessName,
          },
          {
            name: 'le-businessCategory',
            value: seller.category?.name || '',
          },
          {
            name: 'le-address',
            value: seller.address || '',
          },
        ],
      },
      invitees: [
        {
          name: seller.businessName,
          email: seller.email || 'support@couponapp.com', // fallback if email is null
          phone: seller.phone,
        },
        {
          name: seller.businessName,
          email: seller.email || 'support@couponapp.com',
          phone: seller.phone,
        },
      ],
      irn: `seller-agreement-${seller.id}-${Date.now()}`,
    };

    try {
      const response = await fetch(this.API_URL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Auth-Token': this.API_KEY,
        },
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        throw new Error(`Leegality API responded with ${response.status}: ${await response.text()}`);
      }

      const responseData = await response.json() as any;
      const { data } = responseData;
      
      // Upsert the SellerAgreement record
      const agreement = await (prisma as any).sellerAgreement.upsert({
        where: { sellerId },
        update: {
          leegalityDocumentId: data.documentId,
          signUrl: data.signUrl, // Usually the first invitee's signing URL
          status: AgreementStatus.INITIATED,
        },
        create: {
          sellerId,
          leegalityDocumentId: data.documentId,
          signUrl: data.signUrl,
          status: AgreementStatus.INITIATED,
        },
      });

      return agreement;
    } catch (error) {
      console.error('Leegality API Error:', error);
      throw new Error('Failed to initiate Leegality agreement');
    }
  }

  /**
   * Checks the status and updates it in DB if needed (fallback if webhook fails)
   */
  static async checkStatus(sellerId: string) {
    const agreement = await (prisma as any).sellerAgreement.findUnique({
      where: { sellerId },
    });

    if (!agreement) return null;

    // Ideally, we could poll Leegality API to get the latest status if needed
    // using another endpoint. For now, returning the DB state.

    return agreement;
  }
}
