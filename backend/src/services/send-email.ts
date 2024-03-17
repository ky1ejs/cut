import axios from "axios";

const MAILGUN_API_KEY = process.env.MAILGUN_API_KEY;
const MAILGUN_DOMAIN = process.env.MAILGUN_DOMAIN;

export function sendEmail(
  recipient: string,
  subject: string,
  message: string,
): Promise<void> {
  if (!MAILGUN_API_KEY) throw Error("Mailgun API key is null");

  return axios
    .post(
      `https://api.mailgun.net/v3/${MAILGUN_DOMAIN}/messages`,
      new URLSearchParams({
        from: `Cut <no-reply@${MAILGUN_DOMAIN}>`,
        to: recipient,
        subject: subject,
        html: message
      }).toString(),
      {
        auth: {
          username: "api",
          password: MAILGUN_API_KEY,
        },
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
      },
    )
    .then(() => console.log(`email sent to: ${recipient}`));
}
