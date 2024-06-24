import crypto from "crypto"

/* generate a key by: 
 ```bash
  openssl rand -hex 32
 ```
 */
export function encrypt(text: string, encriptionKey: string | undefined): string {
  if (!encriptionKey) {
    throw new Error("no ENCRYPTION_KEY");
  }

  const iv = crypto.randomBytes(16);
  const key = crypto
    .createHash("sha256")
    .update(encriptionKey)
    .digest("base64")
    .substring(0, 32);
  const cipher = crypto.createCipheriv("aes-256-cbc", key, iv);

  let encrypted = cipher.update(text);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  return iv.toString("hex") + ":" + encrypted.toString("hex");
}

export function decrypt(encryptedText: string, encriptionKey: string | undefined): string {
  if (!encriptionKey) {
    throw new Error("no ENCRYPTION_KEY");
  }

  const textParts = encryptedText.split(":");

  const strIV = textParts.shift() ?? "";

  if (!strIV) {
    throw new Error("INVALID_FORMAT");
  }

  const iv = Buffer.from(strIV ?? "", "hex");

  const encryptedData = Buffer.from(textParts.join(":"), "hex");
  const key = crypto
    .createHash("sha256")
    .update(encriptionKey)
    .digest("base64")
    .substring(0, 32);
  const decipher = crypto.createDecipheriv("aes-256-cbc", key, iv);

  const decrypted = decipher.update(encryptedData);
  const decryptedText = Buffer.concat([decrypted, decipher.final()]);

  return decryptedText.toString();
}
