import { Outlet } from "react-router-dom";
import NotificationBell from "./NotificationBell";
import Sidebar from "./Sidebar";
import MobileNav from "./MobileNav";

export default function Layout() {
  return (
    <div className="min-h-screen bg-background font-inter">
      <div className="hidden lg:block">
        <Sidebar />
      </div>
      <main className="lg:ml-60 min-h-screen pb-20 lg:pb-0">
        <div className="flex justify-end px-4 sm:px-6 lg:px-8 pt-4">
          <NotificationBell />
        </div>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <Outlet />
        </div>
      </main>
      <MobileNav />
    </div>
  );
}
