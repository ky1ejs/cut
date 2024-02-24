import boot from "./boot";
import { Worker } from "worker_threads";

const worker = new Worker(__dirname + "/workers/index");

const shutdown = async () => {
  console.log("Shutting down gracefully...");
  await worker.terminate();
  process.exit(0);
};

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);

boot();
