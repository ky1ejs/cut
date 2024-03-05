import CenterScreen from "@/components/CenterScreen";

export default function Home() {
  return (
    <main>
      <div className="background fixed bottom-0 left-0 right-0 top-0" />
      <CenterScreen>
        <div className="text-[80pt]">🎬</div>
      </CenterScreen>
      <div className="fixed bottom-8 w-full">
        <div className=" flex justify-center gap-4">
          <a href="https://www.threads.net/@fbnsz">@fbnsz</a>
          <a href="https://www.threads.net/@_kylejs_">@kylejs</a>
        </div>
      </div>
    </main>
  );
}
