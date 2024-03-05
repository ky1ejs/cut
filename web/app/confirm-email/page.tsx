import CenterScreen from "@/components/CenterScreen";
import Logo from "@/components/Logo";
import { redirect } from "next/navigation";

export default function Page({
  searchParams,
}: {
  searchParams: { [key: string]: string | string[] | undefined };
}) {
  const token = searchParams.token;
  if (!token) {
    redirect("/");
  }
  const url = `cut://confirm-email?token=${token}`;
  return (
    <CenterScreen>
      <div className="m-auto">
        <Logo />
      </div>
      <a href={url}>
        <div className="shadow-m rounded-md bg-gray-700 px-4 py-2 text-white shadow-md shadow-gray-700">
          Confirm Email
        </div>
      </a>
    </CenterScreen>
  );
}
