import { AreaChart, Area, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from "recharts";
import { useMemo } from "react";

const generatePortfolioData = () => {
  const data = [];
  let value = 10000;
  const now = new Date();
  for (let i = 30; i >= 0; i--) {
    const date = new Date(now);
    date.setDate(date.getDate() - i);
    value += (Math.random() - 0.4) * 300;
    value = Math.max(value, 8000);
    data.push({
      date: date.toLocaleDateString("ru-RU", { day: "2-digit", month: "short" }),
      value: Math.round(value * 100) / 100,
    });
  }
  return data;
};

const CustomTooltip = ({ active, payload, label }) => {
  if (!active || !payload?.length) return null;
  return (
    <div className="bg-popover border border-border rounded-lg px-3 py-2 shadow-xl">
      <p className="text-xs text-muted-foreground mb-1">{label}</p>
      <p className="text-sm font-mono font-semibold text-foreground">${payload[0].value.toLocaleString()}</p>
    </div>
  );
};

export default function PortfolioChart() {
  const data = useMemo(() => generatePortfolioData(), []);
  const isPositive = data[data.length - 1]?.value >= data[0]?.value;
  const color = isPositive ? "hsl(160, 84%, 39%)" : "hsl(0, 84%, 60%)";

  return (
    <div className="bg-card border border-border rounded-xl p-5">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-semibold text-foreground">Динамика портфеля</h3>
          <p className="text-xs text-muted-foreground mt-0.5">Последние 30 дней</p>
        </div>
        <div className="text-right">
          <span className="text-lg font-mono font-semibold text-foreground">${data[data.length - 1]?.value.toLocaleString()}</span>
          <span className={`text-xs block ${isPositive ? "text-success" : "text-destructive"}`}>
            {isPositive ? "+" : ""}{((data[data.length - 1]?.value - data[0]?.value) / data[0]?.value * 100).toFixed(2)}%
          </span>
        </div>
      </div>
      <ResponsiveContainer width="100%" height={220}>
        <AreaChart data={data} margin={{ top: 5, right: 5, left: 5, bottom: 0 }}>
          <defs>
            <linearGradient id="portfolioGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor={color} stopOpacity={0.3} />
              <stop offset="100%" stopColor={color} stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid strokeDasharray="3 3" stroke="hsl(222, 30%, 14%)" vertical={false} />
          <XAxis dataKey="date" tick={{ fontSize: 10, fill: "hsl(215, 20%, 55%)" }} axisLine={false} tickLine={false} />
          <YAxis tick={{ fontSize: 10, fill: "hsl(215, 20%, 55%)" }} axisLine={false} tickLine={false} tickFormatter={(v) => `$${(v / 1000).toFixed(1)}k`} domain={["dataMin - 200", "dataMax + 200"]} />
          <Tooltip content={<CustomTooltip />} />
          <Area type="monotone" dataKey="value" stroke={color} strokeWidth={2} fill="url(#portfolioGradient)" />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
