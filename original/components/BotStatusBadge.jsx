const statusConfig = {
  active: { label: "Активен", className: "bg-emerald-500/10 text-emerald-400 border-emerald-500/20", dot: "bg-emerald-400" },
  paused: { label: "Пауза", className: "bg-amber-500/10 text-amber-400 border-amber-500/20", dot: "bg-amber-400" },
  stopped: { label: "Остановлен", className: "bg-slate-500/10 text-slate-400 border-slate-500/20", dot: "bg-slate-500" },
  error: { label: "Ошибка", className: "bg-red-500/10 text-red-400 border-red-500/20", dot: "bg-red-400" },
};

export default function BotStatusBadge({ status }) {
  const config = statusConfig[status] || statusConfig.stopped;
  return (
    <span className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium border ${config.className}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${config.dot} ${status === "active" ? "animate-pulse" : ""}`} />
      {config.label}
    </span>
  );
}
