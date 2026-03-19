import QRCode from 'qrcode';

/**
 * Generates a base64 encoded PNG Data URL for a given string payload.
 * Useful for embedding the QR code directly into an `img` src attribute.
 * @param payload The string (e.g., JWT) to encode into the QR code
 * @returns A promise that resolves to a data URI string
 */
export async function generateQrBase64(payload: string): Promise<string> {
  try {
    return await QRCode.toDataURL(payload, {
      errorCorrectionLevel: 'H',
      margin: 2,
      scale: 8,
      color: {
        dark: '#000000',
        light: '#FFFFFF',
      },
    });
  } catch (error) {
    throw new Error('Failed to generate QR code');
  }
}
