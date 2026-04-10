import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { Request } from 'express';

// Ensure directories exist
const createDir = (dirPath: string) => {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
};

// const UPLOADS_DIR = path.join(__dirname, '../../../../public/uploads');
const UPLOADS_DIR = '/tmp/uploads';
const LOGOS_DIR = path.join(UPLOADS_DIR, 'sellers/logos');
const MEDIA_DIR = path.join(UPLOADS_DIR, 'sellers/media');

createDir(LOGOS_DIR);
createDir(MEDIA_DIR);

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // If it's the logo endpoint or field, use logo dir, else media
    if (file.fieldname === 'logo' || req.path.includes('/logo')) {
      cb(null, LOGOS_DIR);
    } else {
      cb(null, MEDIA_DIR);
    }
  },
  filename: (req, file, cb) => {
    // unique filename
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname);
    cb(null, file.fieldname + '-' + uniqueSuffix + ext);
  },
});

const fileFilter = (req: Request, file: Express.Multer.File, cb: multer.FileFilterCallback) => {
  // Check mime types
  if (file.fieldname === 'video') {
    if (file.mimetype === 'video/mp4' || file.mimetype === 'video/quicktime') {
      cb(null, true);
    } else {
      cb(new Error('Invalid video format. Only MP4 and MOV are allowed.'));
    }
  } else {
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/jpg' || file.mimetype === 'image/png') {
      cb(null, true);
    } else {
      cb(new Error('Invalid image format. Only JPEG, JPG, and PNG are allowed.'));
    }
  }
};

export const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 15 * 1024 * 1024, // 15MB max file size
  },
});
