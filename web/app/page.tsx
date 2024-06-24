import CenterScreen from "@/components/CenterScreen";
import Logo from "@/components/Logo";

export default function Home() {
  return (
    <main>
      <div className="background fixed bottom-0 left-0 right-0 top-0" />
      <CenterScreen>
        <Logo />
      </CenterScreen>
      <div className="fixed bottom-8 w-full">
        <div className="flex justify-center gap-4">
          <a href="https://www.threads.net/@fbnsz">@fbnsz</a>
          <a href="https://www.threads.net/@_kylejs_">@kylejs</a>
        </div>
      </div>
    </main>
  );
}
