import { createHash } from 'crypto';

export default function sha256(input: string): string {
  return createHash('sha256').update(input).digest('base64');
}
