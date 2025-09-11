// app/page.tsx
import Hero from '@/components/Hero';
import LatestSection from '@/components/LatestSection';
import FeaturedReviewSection from '@/components/FeaturedReviewSection';
import ArticlesSection from '@/components/ArticlesSection';
import NewsfeedSection from '@/components/NewsfeedSection';

export default function HomePage() {
  return (
    <>
      <Hero />
      <LatestSection />
      <FeaturedReviewSection />
      <ArticlesSection />
      <NewsfeedSection />
    </>
  );
}