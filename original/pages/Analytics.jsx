import { useQuery } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import {
  PieChart, Pie, Cell, ResponsiveContainer, Tooltip,
  BarChart, Bar, XAxis, YAxis, CartesianGrid, ReferenceLine,
} from "recharts";
import { useMemo } from "react";
import { TrendingUp, TrendingDown, Wallet, Activity, BarChart2, Target } from "lucide-react";

const COLORS = [
  "hsl(187, 92%, 41%)", "hsl(160, 84%, 39%)", "hsl(262, 83%, 58%)",
  "hsl(43, 74%, 66%)", "hsl(0, 84%, 60%)", "hsl(217, 91%, 60%)",
];

const CustomTooltip = ({ active, payload, label }) => {
  if (!active || !payload?.length) return null;
  return (
    <div className="bg-popover border border-border rounded-lg px-3 py-2 shadow-xl text-xs">
      {label && <p className="text-muted-foreground mb-1">{label}</p>}
      {payload.map((p, i) => (
        <p key={i} className="font-mono font-semibold" style={{ color: p.color || "hsl(210,40%,96%)" }}>
          {p.name && <span className="text-muted-foreground mr-1">{p.name}:</span>}
          {typeof p.value === "number" ? (p.value >= 0 ? "+" : "") + "$" + p.value.toFixed(2) : p.value}
        </p>
      ))}
    </div>
  );
};

const PieTooltip = ({ active, payload }) => {
  if (!active || !payload?.length) return null;
  return (
    <div className="bg-popover border border-border rounded-lg px-3 py-2 shadow-xl text-xs">
      <p className="text-muted-foreground">{payload[0].name}</p>
      <p className="font-mono font-semibold text-foreground">${payload[0].value.toLocaleString()}</p>
      <p className="text-muted-foreground">{payload[0].payload.percent}%</p>
    </div>
  );
};

const StatCard = ({ icon: Icon, label, value, sub, positive }) => (
  <div className="bg-card border border-border rounded-xl p-4 flex items-start gap-3">
    <div className="p-2 bg-secondary rounded-lg">
      <Icon className="w-4 h-4 text-primary" />
    </div>
    <div>
      <p className="text-xs text-muted-foreground">{label}</p>
      <p className={`text-xl font-mono font-semibold mt-0.5 ${positive === true ? "text-success" : positive === false ? "text-destructive" : "text-foreground"}`}>
        {value}
      </p>
      {sub && <p className="text-xs text-muted-foreground mt-0.5">{sub}</p>}
    </div>
  </div>
);

export default function Analytics() {
  const { data: bots = [] } = useQuery({
    queryKey: ["bots"],
    queryFn: () => base44.entities.Bot.list(),
  });

  const { data: trades = [] } = useQuery({
    queryKey: ["trades-all"],
    queryFn: () => base44.entities.Trade.list("-created_date", 200),
  });

  const totalBalance = useMemo(() => bots.reduce((s, b) => s + (b.current_balance || b.initial_capital || 0), 0), [bots]);
  const totalInitial = useMemo(() => bots.reduce((s, b) => s + (b.initial_capital || 0), 0), [bots]);
  const totalPnL = useMemo(() => bots.reduce((s, b) => s + (b.profit_loss || 0), 0), [bots]);
  const totalPnLPct = totalInitial > 0 ? (totalPnL / totalInitial) * 100 : 0;
  const winTrades = trades.filter((t) => (t.profit_loss || 0) > 0).length;
  const totalVolume = trades.reduce((s, t) => s + (t.total || 0), 0);
  const avgWinRate = bots.length > 0 ? bots.reduce((s, b) => s + (b.win_rate || 0), 0) / bots.length : 0;

  const botPnLData = useMemo(() =>
    [...bots].sort((a, b) => (b.profit_loss || 0) - (a.profit_loss || 0))
      .map((b) => ({
        name: b.name.length > 14 ? b.name.slice(0, 13) + "…" : b.name,
        pnl: Math.round((b.profit_loss || 0) * 100) / 100,
      })),
    [bots]
  );

  const balanceDistribution = useMemo(() => {
    const total = bots.reduce((s, b) => s + (b.current_balance || b.initial_capital || 0), 0);
    return bots.map((b) => {
      const val = Math.round((b.current_balance || b.initial_capital || 0));
      return {
        name: b.name.length > 16 ? b.name.slice(0, 15) + "…" : b.name,
        value: val,
        percent: total > 0 ? ((val / total) * 100).toFixed(1) : "0",
      };
    });
  }, [bots]);

  const exchangeDistribution = useMemo(() => {
    const map = {};
    bots.forEach((b) => {
      const ex = (b.exchange || "other").toUpperCase();
      map[ex] = (map[ex] || 0) + (b.current_balance || b.initial_capital || 0);
    });
    const total = Object.values(map).reduce((s, v) => s + v, 0);
    return Object.entries(map).map(([name, value]) => ({
      name, value: Math.round(value),
      percent: total > 0 ? ((value / total) * 100).toFixed(1) : "0",
    }));
  }, [bots]);

  const strategyPerf = useMemo(() => {
    const map = {};
    bots.forEach((b) => {
      const key = b.strategy || "other";
      if (!map[key]) map[key] = { pnl: 0, count: 0, winRate: 0 };
      map[key].pnl += b.profit_loss || 0;
      map[key].count += 1;
      map[key].winRate += b.win_rate || 0;
    });
    const labels = { grid: "Grid", dca: "DCA", scalping: "Scalping", arbitrage: "Арбитраж", momentum: "Momentum", mean_reversion: "Mean Rev." };
    return Object.entries(map).map(([key, val]) => ({
      name: labels[key] || key,
      pnl: Math.round(val.pnl * 100) / 100,
      avgWinRate: Math.round(val.winRate / val.count),
      count: val.count,
    }));
  }, [bots]);

  const dailyPnL = useMemo(() => {
    const days = {};
    const now = new Date();
    for (let i = 13; i >= 0; i--) {
      const d = new Date(now);
      d.setDate(d.getDate() - i);
      const key = d.toISOString().slice(0, 10);
      const label = d.toLocaleDateString("ru-RU", { day: "2-digit", month: "short" });
      days[key] = { date: label, pnl: 0 };
    }
    trades.forEach((t) => {
      const key = (t.executed_at || t.created_date || "").slice(0, 10);
      if (days[key]) days[key].pnl += t.profit_loss || 0;
    });
    return Object.values(days).map((d) => ({ ...d, pnl: Math.round(d.pnl * 100) / 100 }));
  }, [trades]);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold text-foreground tracking-tight">Аналитика</h1>
        <p className="text-sm text-muted-foreground mt-1">Детальный анализ портфеля и торговой активности</p>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-3">
        <StatCard icon={Wallet} label="Общий баланс" value={`$${totalBalance.toLocaleString(undefined, { maximumFractionDigits: 0 })}`} sub={`Вложено: $${totalInitial.toLocaleString()}`} />
        <StatCard icon={totalPnL >= 0 ? TrendingUp : TrendingDown} label="Общий PnL" value={`${totalPnL >= 0 ? "+" : ""}$${totalPnL.toFixed(2)}`} sub={`${totalPnLPct >= 0 ? "+" : ""}${totalPnLPct.toFixed(2)}%`} positive={totalPnL >= 0} />
        <StatCard icon={Activity} label="Всего сделок" value={trades.length} sub={`Прибыльных: ${winTrades}`} />
        <StatCard icon={Target} label="Средний Win Rate" value={`${avgWinRate.toFixed(1)}%`} sub="По всем ботам" positive={avgWinRate >= 50} />
        <StatCard icon={BarChart2} label="Объём торгов" value={`$${(totalVolume / 1000).toFixed(1)}k`} sub={`${trades.length} сделок`} />
        <StatCard icon={Activity} label="Активных ботов" value={bots.filter((b) => b.status === "active").length} sub={`Всего: ${bots.length}`} />
      </div>

      <div className="bg-card border border-border rounded-xl p-5">
        <h3 className="font-semibold text-foreground mb-1">Прибыльность ботов</h3>
        <p className="text-xs text-muted-foreground mb-4">PnL каждого бота в долларах</p>
        {botPnLData.length === 0 ? (
          <div className="h-48 flex items-center justify-center text-sm text-muted-foreground">Нет данных</div>
        ) : (
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={botPnLData} margin={{ top: 5, right: 5, left: 5, bottom: 40 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" vertical={false} />
              <XAxis dataKey="name" tick={{ fontSize: 10, fill: "hsl(215,20%,55%)" }} axisLine={false} tickLine={false} angle={-35} textAnchor="end" interval={0} />
              <YAxis tick={{ fontSize: 10, fill: "hsl(215,20%,55%)" }} axisLine={false} tickLine={false} tickFormatter={(v) => `$${v}`} />
              <Tooltip content={<CustomTooltip />} />
              <ReferenceLine y={0} stroke="hsl(var(--border))" strokeWidth={1} />
              <Bar dataKey="pnl" name="PnL" radius={[4, 4, 0, 0]}>
                {botPnLData.map((entry, i) => (
                  <Cell key={i} fill={entry.pnl >= 0 ? "hsl(160,84%,39%)" : "hsl(0,84%,60%)"} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>

      <div className="grid lg:grid-cols-2 gap-6">
        <div className="bg-card border border-border rounded-xl p-5">
          <h3 className="font-semibold text-foreground mb-1">Ежедневный PnL</h3>
          <p className="text-xs text-muted-foreground mb-4">Последние 14 дней</p>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={dailyPnL} margin={{ top: 5, right: 5, left: 5, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" vertical={false} />
              <XAxis dataKey="date" tick={{ fontSize: 9, fill: "hsl(215,20%,55%)" }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 10, fill: "hsl(215,20%,55%)" }} axisLine={false} tickLine={false} tickFormatter={(v) => `$${v}`} />
              <Tooltip content={<CustomTooltip />} />
              <ReferenceLine y={0} stroke="hsl(var(--border))" />
              <Bar dataKey="pnl" name="PnL" radius={[3, 3, 0, 0]}>
                {dailyPnL.map((entry, i) => (
                  <Cell key={i} fill={entry.pnl >= 0 ? "hsl(160,84%,39%)" : "hsl(0,84%,60%)"} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-card border border-border rounded-xl p-5">
          <h3 className="font-semibold text-foreground mb-1">Распределение баланса</h3>
          <p className="text-xs text-muted-foreground mb-4">По ботам</p>
          {balanceDistribution.length === 0 ? (
            <div className="h-[220px] flex items-center justify-center text-sm text-muted-foreground">Нет данных</div>
          ) : (
            <div className="flex items-center gap-4">
              <ResponsiveContainer width="50%" height={200}>
                <PieChart>
                  <Pie data={balanceDistribution} cx="50%" cy="50%" innerRadius={50} outerRadius={80} paddingAngle={2} dataKey="value">
                    {balanceDistribution.map((_, i) => <Cell key={i} fill={COLORS[i % COLORS.length]} />)}
                  </Pie>
                  <Tooltip content={<PieTooltip />} />
                </PieChart>
              </ResponsiveContainer>
              <div className="flex-1 space-y-1.5 min-w-0">
                {balanceDistribution.slice(0, 6).map((item, i) => (
                  <div key={item.name} className="flex items-center gap-2 text-xs">
                    <span className="w-2 h-2 rounded-full flex-shrink-0" style={{ backgroundColor: COLORS[i % COLORS.length] }} />
                    <span className="text-muted-foreground truncate flex-1">{item.name}</span>
                    <span className="font-mono text-foreground font-medium">{item.percent}%</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      <div className="grid lg:grid-cols-2 gap-6">
        <div className="bg-card border border-border rounded-xl p-5">
          <h3 className="font-semibold text-foreground mb-1">По биржам</h3>
          <p className="text-xs text-muted-foreground mb-4">Распределение баланса</p>
          {exchangeDistribution.length === 0 ? (
            <div className="h-[220px] flex items-center justify-center text-sm text-muted-foreground">Нет данных</div>
          ) : (
            <div className="flex items-center gap-4">
              <ResponsiveContainer width="50%" height={200}>
                <PieChart>
                  <Pie data={exchangeDistribution} cx="50%" cy="50%" innerRadius={50} outerRadius={80} paddingAngle={2} dataKey="value">
                    {exchangeDistribution.map((_, i) => <Cell key={i} fill={COLORS[i % COLORS.length]} />)}
                  </Pie>
                  <Tooltip content={<PieTooltip />} />
                </PieChart>
              </ResponsiveContainer>
              <div className="flex-1 space-y-2">
                {exchangeDistribution.map((item, i) => (
                  <div key={item.name} className="flex items-center gap-2 text-xs">
                    <span className="w-2 h-2 rounded-full flex-shrink-0" style={{ backgroundColor: COLORS[i % COLORS.length] }} />
                    <span className="text-muted-foreground flex-1">{item.name}</span>
                    <span className="font-mono text-foreground font-medium">{item.percent}%</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        <div className="bg-card border border-border rounded-xl p-5">
          <h3 className="font-semibold text-foreground mb-1">По стратегиям</h3>
          <p className="text-xs text-muted-foreground mb-4">PnL и Win Rate</p>
          {strategyPerf.length === 0 ? (
            <div className="h-[220px] flex items-center justify-center text-sm text-muted-foreground">Нет данных</div>
          ) : (
            <ResponsiveContainer width="100%" height={200}>
              <BarChart data={strategyPerf} margin={{ top: 5, right: 5, left: 5, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" vertical={false} />
                <XAxis dataKey="name" tick={{ fontSize: 10, fill: "hsl(215,20%,55%)" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 10, fill: "hsl(215,20%,55%)" }} axisLine={false} tickLine={false} tickFormatter={(v) => `$${v}`} />
                <Tooltip content={<CustomTooltip />} />
                <ReferenceLine y={0} stroke="hsl(var(--border))" />
                <Bar dataKey="pnl" name="PnL" radius={[4, 4, 0, 0]}>
                  {strategyPerf.map((entry, i) => (
                    <Cell key={i} fill={entry.pnl >= 0 ? "hsl(187,92%,41%)" : "hsl(0,84%,60%)"} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          )}
        </div>
      </div>

      <div className="bg-card border border-border rounded-xl p-5">
        <h3 className="font-semibold text-foreground mb-4">Сравнение ботов</h3>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="text-xs text-muted-foreground border-b border-border">
                <th className="text-left pb-3 font-medium">Бот</th>
                <th className="text-right pb-3 font-medium">Баланс</th>
                <th className="text-right pb-3 font-medium">PnL</th>
                <th className="text-right pb-3 font-medium">PnL %</th>
                <th className="text-right pb-3 font-medium">Win Rate</th>
                <th className="text-right pb-3 font-medium hidden sm:table-cell">Просадка</th>
                <th className="text-right pb-3 font-medium hidden md:table-cell">Сделки</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {[...bots].sort((a, b) => (b.profit_loss || 0) - (a.profit_loss || 0)).map((bot) => {
                const pnl = bot.profit_loss || 0;
                const pct = bot.profit_loss_percent || 0;
                return (
                  <tr key={bot.id} className="hover:bg-secondary/30 transition-colors">
                    <td className="py-3">
                      <div className="font-medium text-foreground">{bot.name}</div>
                      <div className="text-xs text-muted-foreground">{bot.exchange?.toUpperCase()} · {bot.trading_pair}</div>
                    </td>
                    <td className="py-3 text-right font-mono text-foreground">${(bot.current_balance || bot.initial_capital || 0).toLocaleString()}</td>
                    <td className={`py-3 text-right font-mono font-semibold ${pnl >= 0 ? "text-success" : "text-destructive"}`}>
                      {pnl >= 0 ? "+" : ""}${pnl.toFixed(2)}
                    </td>
                    <td className={`py-3 text-right font-mono ${pct >= 0 ? "text-success" : "text-destructive"}`}>
                      {pct >= 0 ? "+" : ""}{pct.toFixed(2)}%
                    </td>
                    <td className="py-3 text-right font-mono text-foreground">{(bot.win_rate || 0).toFixed(1)}%</td>
                    <td className="py-3 text-right font-mono text-destructive hidden sm:table-cell">{(bot.max_drawdown || 0).toFixed(1)}%</td>
                    <td className="py-3 text-right font-mono text-muted-foreground hidden md:table-cell">{bot.total_trades || 0}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
