import { Router } from 'express';
import { AdminNichesController } from './admin-niches.controller';
import { validate } from '../../../shared/middlewares/validate';
import { createNicheSchema, updateNicheSchema } from './admin-niches.validator';

const router = Router();
const controller = new AdminNichesController();

router.get('/', controller.list);
router.post('/', validate(createNicheSchema), controller.create);
router.patch('/:id', validate(updateNicheSchema), controller.update);
router.delete('/:id', controller.delete);

export { router as adminNichesRouter };
