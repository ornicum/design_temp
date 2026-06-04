import { useQuery } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { ArrowUpRight, ArrowDownRight } from "lucide-react";
import moment from "moment";

export default function RecentTradesTable({ limit = 8, botId = null }) {
  const { data: trades = [], isLoading } = useQuery({
    queryKey: ["trades", { botId, limit }],
    queryFn: () => botId
      ? base44.entities.Trade.filter({ bot_id: botId }, "-created_date", limit)
      : base44.entities.Trade.list("-created_date", limit),
  });

  if (isLoading) {
    return (
      <div className="bg-card border border-border rounded-xl p-5">
        <div className="animate-pulse space-y-3">
          <div className="h-5 bg-muted rounded w-32" />
          {Array.from({ length: 4 }).map((_, i) => <div key={i} className="h-10 bg-muted rounded" />)}
        </div>
      </div>
    );
  }

  return (
    <div className="bg-card border border-border rounded-xl p-5">
      <h3 className="font-semibold text-foreground mb-4">Последние сделки</h3>
      {trades.length === 0 ? (
        <div className="py-8 text-center">
          <p className="text-muted-foreground text-sm">Пока нет сделок</p>
          <p className="text-muted-foreground text-xs mt-1">Запустите бота, чтобы увидеть торговую активность</p>
        </div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="text-xs text-muted-foreground border-b border-border">
                <th className="text-left pb-3 font-medium">Пара</th>
                <th className="text-left pb-3 font-medium">Тип</th>
                <th className="text-right pb-3 font-medium">Цена</th>
                <th className="text-right pb-3 font-medium">Объём</th>
                <th className="text-right pb-3 font-medium">PnL</th>
                <th className="text-right pb-3 font-medium hidden sm:table-cell">Время</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {trades.map((trade) => (
                <tr key={trade.id} className="group hover:bg-muted/50 transition-colors">
                  <td className="py-3 text-sm font-mono text-foreground">{trade.trading_pair}</td>
                  <td className="py-3">
                    <span className={`inline-flex items-center gap-1 text-xs font-medium ${trade.type === "buy" ? "text-success" : "text-destructive"}`}>
                      {trade.type === "buy" ? <ArrowUpRight className="w-3 h-3" /> : <ArrowDownRight className="w-3 h-3" />}
                      {trade.type === "buy" ? "Покупка" : "Продажа"}
                    </span>
                  </td>
                  <td className="py-3 text-sm font-mono text-foreground text-right">${trade.price?.toLocaleString()}</td>
                  <td className="py-3 text-sm font-mono text-muted-foreground text-right">${trade.total?.toLocaleString()}</td>
                  <td className="py-3 text-right">
                    <span className={`text-sm font-mono ${(trade.profit_loss || 0) >= 0 ? "text-success" : "text-destructive"}`}>
                      {(trade.profit_loss || 0) >= 0 ? "+" : ""}{(trade.profit_loss || 0).toFixed(2)}$
                    </span>
                  </td>
                  <td className="py-3 text-xs text-muted-foreground text-right hidden sm:table-cell">
                    {trade.executed_at ? moment(trade.executed_at).format("HH:mm DD.MM") : moment(trade.created_date).format("HH:mm DD.MM")}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
