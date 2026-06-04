import { TrendingUp, TrendingDown } from "lucide-react";

export default function StatCard({ title, value, change, changeLabel, icon: Icon, variant = "default" }) {
  const isPositive = change >= 0;

  return (
    <div className="bg-card border border-border rounded-xl p-5 hover:border-primary/30 transition-all duration-300 group">
      <div className="flex items-start justify-between mb-3">
        <span className="text-sm text-muted-foreground font-medium">{title}</span>
        {Icon && (
          <div className="w-9 h-9 rounded-lg bg-primary/10 flex items-center justify-center group-hover:bg-primary/20 transition-colors">
            <Icon className="w-4 h-4 text-primary" />
          </div>
        )}
      </div>
      <div className="flex items-end gap-3">
        <span className={`text-2xl font-semibold tracking-tight ${variant === "success" ? "text-success" : variant === "danger" ? "text-destructive" : "text-foreground"}`}>
          {value}
        </span>
        {change !== undefined && (
          <span className={`flex items-center gap-1 text-xs font-medium pb-0.5 ${isPositive ? "text-success" : "text-destructive"}`}>
            {isPositive ? <TrendingUp className="w-3 h-3" /> : <TrendingDown className="w-3 h-3" />}
            {isPositive ? "+" : ""}{change}%
          </span>
        )}
      </div>
      {changeLabel && <span className="text-xs text-muted-foreground mt-1 block">{changeLabel}</span>}
    </div>
  );
}
