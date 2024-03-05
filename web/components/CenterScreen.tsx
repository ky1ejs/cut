
const CenterScreen = ({children}: {children: React.ReactNode}) => (
  <div className="fixed bottom-0 left-0 right-0 top-0 flex text-center">
    <div className="mx-auto my-auto sm:my-auto">{children}</div>
  </div>
)

export default CenterScreen
