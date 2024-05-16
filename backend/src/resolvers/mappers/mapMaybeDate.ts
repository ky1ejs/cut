
export default function mapMaybeDate(date: string | undefined): Date | null {
  if (date) {
    return new Date(date);
  }
  return null;
}
