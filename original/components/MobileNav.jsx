import { Link, useLocation } from "react-router-dom";
import { LayoutDashboard, Bot, BarChart3, Settings, Key } from "lucide-react";

const navItems = [
  { path: "/", icon: LayoutDashboard, label: "Дашборд" },
  { path: "/bots", icon: Bot, label: "Боты" },
  { path: "/analytics", icon: BarChart3, label: "Аналитика" },
  { path: "/api-keys", icon: Key, label: "Ключи" },
  { path: "/settings", icon: Settings, label: "Ещё" },
];

export default function MobileNav() {
  const location = useLocation();

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-card border-t border-border z-50 lg:hidden safe-area-bottom">
      <div className="flex items-center justify-around h-16 px-2">
        {navItems.map(({ path, icon: Icon, label }) => {
          const isActive = path === "/" ? location.pathname === "/" : location.pathname.startsWith(path);
          return (
            <Link
              key={path}
              to={path}
              className={`flex flex-col items-center gap-1 px-2 py-1 rounded-lg transition-colors ${isActive ? "text-primary" : "text-muted-foreground"}`}
            >
              <Icon className="w-5 h-5" />
              <span className="text-[10px] font-medium">{label}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
