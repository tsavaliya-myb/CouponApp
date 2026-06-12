import { prisma } from '../../config/db';
import { AgreementStatus } from '@prisma/client';

export class LeegalityService {
  static get API_URL() { return process.env.LEEGALITY_API_URL || ''; }
  static get API_KEY() { return process.env.LEEGALITY_API_KEY || ''; }
  static get PROFILE_ID() { return process.env.LEEGALITY_PROFILE_ID || ''; }

  /**
   * Initiates the agreement signing process for a seller
   */
  static async initiateAgreement(sellerId: string) {
    const seller = await prisma.seller.findUnique({
      where: { id: sellerId },
      include: { category: true, city: true, area: true },
    });

    if (!seller) {
      throw new Error('Seller not found');
    }

    const inviteeName = (seller as any).fullName || seller.businessName;

    // Format today's date as dd/mm/yyyy
    const today = new Date();
    const dd = String(today.getDate()).padStart(2, '0');
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const yyyy = today.getFullYear();
    const cdate = `${dd}/${mm}/${yyyy}`;

    // cdateplus1 = same day next year
    const nextYear = new Date(today);
    nextYear.setFullYear(nextYear.getFullYear() + 1);
    const dd1 = String(nextYear.getDate()).padStart(2, '0');
    const mm1 = String(nextYear.getMonth() + 1).padStart(2, '0');
    const yyyy1 = nextYear.getFullYear();
    const cdateplus1 = `${dd1}/${mm1}/${yyyy1}`;

    const payload = {
      profileId: LeegalityService.PROFILE_ID,
      file: {
        name: `Seller Agreement - ${seller.businessName} - ${cdate}`,
        fields: [
          // Business details (b-prefixed)
          { id: '1781076484248', name: 'bname', value: seller.businessName },
          { id: '1781207937551', name: 'bcategory', value: (seller as any).category?.name || '' },
          { id: '1781208096818', name: 'barea', value: (seller as any).area?.name || '' },
          { id: '1781208112908', name: 'bpincode', value: (seller as any).pincode || '' },
          { id: '1781208181193', name: 'bmobile', value: seller.phone },
          { id: '1781208343841', name: 'bemail', value: seller.email || '' },
          { id: '1781209030351', name: 'baddress', value: seller.address || '' },
          { id: '1781209068353', name: 'bcity', value: (seller as any).city?.name || '' },

          // Date fields (same value, multiple occurrences in template)
          { id: '1781208392190', name: 'cdate', value: cdate, type: 'date', format: 'dd/mm/yyyy' },
          { id: '1781208431203', name: 'cdateplus1', value: cdateplus1, type: 'date', format: 'dd/mm/yyyy' },
          { id: '1781208638466', name: 'cdate', value: cdate, type: 'date', format: 'dd/mm/yyyy' },
          { id: '1781208725568', name: 'cdate', value: cdate, type: 'date', format: 'dd/mm/yyyy' },

          // Second occurrence of bname in template (separate field ID)
          { id: '1781208618018', name: 'bname', value: seller.businessName },

          // Second occurrence of bcity in template (separate field ID, required)
          { id: '1781208705104', name: 'bcity', value: (seller as any).city?.name || '' },

          // Seller full name
          { id: '1781209290158', name: 'sname', value: (seller as any).fullName || seller.businessName },
        ],
      },
      invitees: [
        {
          // First invitee = the seller Adhar
          name: inviteeName,
          email: seller.email || '',
          phone: seller.phone,
        },
        {
          // Second invitee = the seller virtual sign
          name: inviteeName,
          email: seller.email || '',
          phone: seller.phone,
        },
      ],
      irn: `seller-${seller.id}-${Date.now()}`,
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

      // Extract signUrl from the first invitee
      const signUrl = data.invitees?.[0]?.signUrl || '';

      // Upsert the SellerAgreement record
      const agreement = await (prisma as any).sellerAgreement.upsert({
        where: { sellerId },
        update: {
          leegalityDocumentId: data.documentId,
          signUrl: signUrl,
          status: AgreementStatus.INITIATED,
        },
        create: {
          sellerId,
          leegalityDocumentId: data.documentId,
          signUrl: signUrl,
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
