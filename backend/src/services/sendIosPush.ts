import jwt from "jsonwebtoken";
import http2 from "http2";
import { PushToken, TokenEnv } from "@prisma/client";

function parseKey(): string | undefined {
  const base64EncodedKey = process.env.APPLE_P8;
  if (!base64EncodedKey) {
    return undefined;
  }

  return Buffer.from(base64EncodedKey, "base64").toString("utf-8");
}

const KEY = parseKey();
const KEY_ID = process.env.APPLE_P8_KEY_ID;

export type PushMessage = {
  title: string;
  body: string;
  badge?: number;
};

export function sendIosPush(
  deviceToken: PushToken,
  { title, body, badge }: PushMessage
): Promise<void> {
  const path = `/3/device/${deviceToken.token}`;
  const bearerToken = createBearerToken();
  const pushPayload = {
    aps: {
      alert: {
        title: title,
        body: body,
      },
      badge: badge,
    }
  };
  const headers = {
    ":method": "POST",
    "apns-push-type": "alert",
    "apns-topic": "watch.cut", // your application bundle ID
    ":scheme": "https",
    ":path": path,
    authorization: `bearer ${bearerToken}`,
  };

  return new Promise((resolve, reject) => {
    const client = http2.connect(getHostForEnv(deviceToken.env));
    client.on("error", (err) => {
      reject(err)
      console.log(err)
    });
    const request = client.request(headers);
    request.on("response", (headers) => {
      for (const name in headers) {
        console.log(`${name}: ${headers[name]}`);
      }
    });

    request.setEncoding("utf8");
    let data = "";
    request.on("data", (chunk) => {
      data += chunk;
    });
    request.write(JSON.stringify(pushPayload));
    request.on("end", () => {
      console.log(`\n${data}`);
      resolve();
      client.close();
    });
    request.end();
  });
}

// "iat" should not be older than 1 hr from current time or will get rejected
function createBearerToken(): string {
  if (!KEY) throw new Error("No push key");
  if (!KEY_ID) throw new Error("No key ID")

  try {
    return jwt.sign(
      {
        iss: "X2TBSUCASC", // "team ID" of your developer account
        iat: Math.floor(new Date().getTime() / 1000), // Replace with current unix epoch time [Not in milliseconds, frustated me :D]
      },
      KEY,
      {
        header: {
          alg: "ES256",
          kid: KEY_ID, // issuer key which is "key ID" of your p8 file
        },
      }
    );
  } catch (e) {
    console.log(e)
    throw e
  }
}

function getHostForEnv(env: TokenEnv): string {
  switch (env) {
    case TokenEnv.STAGING:
      return "https://api.sandbox.push.apple.com";
    case TokenEnv.PRODUCTION:
      return "https://api.push.apple.com";
  }
}
