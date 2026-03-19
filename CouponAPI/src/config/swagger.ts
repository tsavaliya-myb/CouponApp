import {
  OpenAPIRegistry,
  OpenApiGeneratorV3,
  extendZodWithOpenApi,
} from '@asteasolutions/zod-to-openapi';
import { z } from 'zod';
import swaggerUi from 'swagger-ui-express';
import { Express } from 'express';

// Extend Zod once before using .openapi() on schemas
extendZodWithOpenApi(z);

export const openApiRegistry = new OpenAPIRegistry();

// Register the Bearer Auth security scheme for the entire API
openApiRegistry.registerComponent('securitySchemes', 'bearerAuth', {
  type: 'http',
  scheme: 'bearer',
  bearerFormat: 'JWT',
  description: 'Enter your Bearer token in the format **Bearer <token>**',
});

// A helper to generate the final OpenAPI JSON document
export function generateOpenApiDocument() {
  const generator = new OpenApiGeneratorV3(openApiRegistry.definitions);
  return generator.generateDocument({
    openapi: '3.0.0',
    info: {
      title: 'CouponApp API',
      version: '1.0.0',
      description: 'API documentation for the CouponApp backend',
    },
    servers: [{ url: '/api/v1' }],
  });
}

// Attach the Swagger UI middleware to Express
export function setupSwagger(app: Express) {
  const swaggerDocument = generateOpenApiDocument();
  app.use(
    '/api/docs',
    swaggerUi.serve,
    swaggerUi.setup(swaggerDocument, {
      explorer: true,
      customCss: '.swagger-ui .topbar { display: none }',
    })
  );
}
