import { updateAllCollections } from "./updateCollections"

function process() {
  return updateAllCollections()
}

function schedule() {
  console.log("Workers finished, scheduling next run in 1 hour.");
  setTimeout(function () {
    console.log("Workers starting...");
    start();
  }, 1000 * 60 * 60);
}

const start = () => {
  console.log("Running worker...");
  process()
    .then(schedule)
    .catch((err) => {
      console.error("Error in workers", err);
      throw err;
    });
};

start()
