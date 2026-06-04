import { useQuery } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { useAuth } from "@/lib/AuthContext";
import { Wallet, Bot, Activity, TrendingUp } from "lucide-react";
import StatCard from "../components/StatCard";
import PortfolioChart from "../components/PortfolioChart";
import RecentTradesTable from "../components/RecentTradesTable";
import BotCard from "../components/BotCard";
import { Link } from "react-router-dom";

export default function Dashboard() {
  const { user } = useAuth();
  const { data: bots = [], isLoading } = useQuery({
    queryKey: ["bots"],
    queryFn: () => base44.entities.Bot.list("-created_date"),
  });

  const activeBots = bots.filter((b) => b.status === "active");
  const totalBalance = bots.reduce((sum, b) => sum + (b.current_balance || b.initial_capital || 0), 0);
  const totalPnL = bots.reduce((sum, b) => sum + (b.profit_loss || 0), 0);
  const totalTrades = bots.reduce((sum, b) => sum + (b.total_trades || 0), 0);
  const avgWinRate = bots.length ? bots.reduce((sum, b) => sum + (b.win_rate || 0), 0) / bots.length : 0;

  if (isLoading) {
    return (
      <div className="space-y-6 animate-pulse">
        <div className="h-8 bg-muted rounded w-48" />
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          {Array.from({ length: 4 }).map((_, i) => <div key={i} className="h-28 bg-muted rounded-xl" />)}
        </div>
        <div className="h-72 bg-muted rounded-xl" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold text-foreground tracking-tight">
          Добро пожаловать{user?.full_name ? `, ${user.full_name}` : ""}
        </h1>
        <p className="text-sm text-muted-foreground mt-1">Обзор вашего торгового портфеля</p>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard title="Общий баланс" value={`$${totalBalance.toLocaleString()}`} change={totalPnL ? (totalPnL / (totalBalance - totalPnL) * 100) : 0} icon={Wallet} />
        <StatCard title="Активные боты" value={`${activeBots.length} / ${bots.length}`} icon={Bot} />
        <StatCard title="Общий PnL" value={`${totalPnL >= 0 ? "+" : ""}$${totalPnL.toFixed(2)}`} variant={totalPnL >= 0 ? "success" : "danger"} icon={TrendingUp} />
        <StatCard title="Всего сделок" value={totalTrades.toLocaleString()} changeLabel={`Win Rate: ${avgWinRate.toFixed(1)}%`} icon={Activity} />
      </div>

      <PortfolioChart />

      {activeBots.length > 0 && (
        <div>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-lg font-semibold text-foreground">Активные боты</h2>
            <Link to="/bots" className="text-sm text-primary hover:text-primary/80 transition-colors">Все боты →</Link>
          </div>
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {activeBots.slice(0, 3).map((bot) => <BotCard key={bot.id} bot={bot} />)}
          </div>
        </div>
      )}

      <RecentTradesTable limit={6} />
    </div>
  );
}
