import { Router } from 'express';
import { LeegalityWebhookController } from './leegality-webhook.controller';

const router = Router();
const controller = new LeegalityWebhookController();

router.post('/', controller.handleWebhook);

export { router as leegalityWebhookRouter };
