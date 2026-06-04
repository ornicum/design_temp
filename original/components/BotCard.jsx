import { Link } from "react-router-dom";
import { ArrowUpRight, ArrowDownRight } from "lucide-react";
import BotStatusBadge from "./BotStatusBadge";

const exchangeColors = {
  binance: "text-amber-400",
  bybit: "text-orange-400",
  okx: "text-blue-400",
  kucoin: "text-emerald-400",
  kraken: "text-violet-400",
};

const strategyLabels = {
  grid: "Grid Trading", dca: "DCA", scalping: "Scalping",
  arbitrage: "Арбитраж", momentum: "Momentum", mean_reversion: "Mean Reversion",
};

export default function BotCard({ bot }) {
  const isPositive = (bot.profit_loss || 0) >= 0;

  return (
    <Link
      to={`/bots/${bot.id}`}
      className="block bg-card border border-border rounded-xl p-5 hover:border-primary/30 hover:shadow-lg hover:shadow-primary/5 transition-all duration-300 group"
    >
      <div className="flex items-start justify-between mb-4">
        <div>
          <h3 className="font-semibold text-foreground group-hover:text-primary transition-colors">{bot.name}</h3>
          <div className="flex items-center gap-2 mt-1">
            <span className={`text-xs font-mono ${exchangeColors[bot.exchange] || "text-muted-foreground"}`}>{bot.exchange?.toUpperCase()}</span>
            <span className="text-muted-foreground text-xs">·</span>
            <span className="text-xs text-muted-foreground">{bot.trading_pair}</span>
          </div>
        </div>
        <BotStatusBadge status={bot.status} />
      </div>

      <div className="flex items-center justify-between">
        <div>
          <span className="text-xs text-muted-foreground block mb-0.5">PnL</span>
          <div className="flex items-center gap-1.5">
            {isPositive ? <ArrowUpRight className="w-4 h-4 text-success" /> : <ArrowDownRight className="w-4 h-4 text-destructive" />}
            <span className={`font-mono font-semibold text-sm ${isPositive ? "text-success" : "text-destructive"}`}>
              {isPositive ? "+" : ""}{(bot.profit_loss || 0).toFixed(2)}$
            </span>
            <span className={`text-xs ${isPositive ? "text-success/70" : "text-destructive/70"}`}>
              ({isPositive ? "+" : ""}{(bot.profit_loss_percent || 0).toFixed(1)}%)
            </span>
          </div>
        </div>
        <div className="text-right">
          <span className="text-xs text-muted-foreground block mb-0.5">Стратегия</span>
          <span className="text-xs font-medium text-secondary-foreground">{strategyLabels[bot.strategy] || bot.strategy}</span>
        </div>
      </div>

      <div className="flex items-center justify-between mt-4 pt-3 border-t border-border">
        <div className="flex items-center gap-4">
          <div>
            <span className="text-[10px] text-muted-foreground block">Сделки</span>
            <span className="text-xs font-mono text-foreground">{bot.total_trades || 0}</span>
          </div>
          <div>
            <span className="text-[10px] text-muted-foreground block">Win Rate</span>
            <span className="text-xs font-mono text-foreground">{(bot.win_rate || 0).toFixed(1)}%</span>
          </div>
          <div>
            <span className="text-[10px] text-muted-foreground block">Просадка</span>
            <span className="text-xs font-mono text-foreground">{(bot.max_drawdown || 0).toFixed(1)}%</span>
          </div>
        </div>
        <span className="text-xs text-muted-foreground font-mono">${(bot.current_balance || bot.initial_capital || 0).toLocaleString()}</span>
      </div>
    </Link>
  );
}
