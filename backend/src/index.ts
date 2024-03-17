import boot from "./boot";
import { Worker } from "worker_threads";

let worker: Worker | undefined

console.log(`WORKER: ${process.env.WORKER}`)
if ((process.env.WORKER || 'true') === 'true') {
  const worker = new Worker(__dirname + "/workers/index");
}

const shutdown = async () => {
  console.log("Shutting down gracefully...");
  if (worker) {
    await worker.terminate();
  }
  process.exit(0);
};

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);

boot();
