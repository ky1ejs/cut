import CenterScreen from "@/components/CenterScreen"
import Logo from "@/components/Logo"
import { redirect, useSearchParams } from "next/navigation"

export default function Page({searchParams}: {searchParams:  { [key: string]: string | string[] | undefined }}) {
  const token = searchParams.token
  if (!token) {
    redirect("/")
  }
  const url = `cut://confirm-email?token=${token}`
  return (
    <CenterScreen>
      <div className="m-auto">
      <Logo/>
      </div>
      <a href={url}>
        <div className="px-4 py-2 bg-gray-700 rounded-md text-white shadow-m shadow-gray-700 shadow-md">
          Confirm Email
        </div>
      </a>
    </CenterScreen>
  )
}