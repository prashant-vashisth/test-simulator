interface Props {
  formattedTime: string;
}

export function Timer({ formattedTime }: Props) {
  return (
    <div className="flex items-center gap-1.5 bg-gray-100 rounded-xl px-3 py-1.5">
      <span className="text-lg">⏱️</span>
      <span className="font-mono text-sm font-bold text-gray-700">{formattedTime}</span>
    </div>
  );
}
