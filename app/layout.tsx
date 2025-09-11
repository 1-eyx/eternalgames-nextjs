import { Poppins, Lora, Inter } from 'next/font/google';
import './globals.css';
import Navbar from '@/components/Navbar';
import Footer from '@/components/Footer';
import { ThemeProvider } from '@/components/ThemeProvider';
import NextAuthProvider from '@/components/SessionProvider';

const poppins = Poppins({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-heading',
  weight: ['700', '800'],
});

const lora = Lora({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-body',
  style: ['normal', 'italic'],
});

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-ui',
});

export const metadata = {
  title: 'EternalGames',
  description: 'Games Are Forever.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${poppins.variable} ${lora.variable} ${inter.variable}`} suppressHydrationWarning>
      <body>
        <NextAuthProvider>
          <ThemeProvider
            attribute="data-theme"
            defaultTheme="system"
            enableSystem
            disableTransitionOnChange
          >
            <Navbar />
            <main>{children}</main>
            <Footer />
          </ThemeProvider>
        </NextAuthProvider>
      </body>
    </html>
  );
}