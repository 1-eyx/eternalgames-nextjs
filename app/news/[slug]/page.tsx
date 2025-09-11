import { newsItems } from '@/lib/data';
import { notFound } from 'next/navigation';
import Image from 'next/image';
import TagLinks from '@/components/TagLinks';
import GiscusComments from '@/components/GiscusComments';

type NewsPageProps = { params: { slug: string; }; };

export default function NewsArticlePage({ params }: NewsPageProps) {
  const newsItem = newsItems.find(n => n.slug === params.slug);

  if (!newsItem) {
    notFound();
  }

  return (
    <>
      <div className="container page-container">
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <p className="news-card-category" style={{ textAlign: 'center', fontSize: '1.6rem' }}>{newsItem.category}</p>
          <h1 className="page-title" style={{ marginBottom: '1rem' }}>{newsItem.title}</h1>
          <p style={{ color: 'var(--text-secondary)', marginBottom: '3rem', textAlign: 'center' }}>Published: {newsItem.date}</p>
          
          <div className="review-hero-image">
            <Image 
              src={newsItem.imageUrl} 
              alt={newsItem.title} 
              fill 
              style={{ objectFit: 'cover' }} 
              priority 
              placeholder="blur"
              blurDataURL={newsItem.blurDataURL}
            />
          </div>
          
          <div className="article-body">
              {/* CORRECTED: Escaped quotes */}
              <p>This is placeholder content for the news article titled &quot;{newsItem.title}&quot;. In a real implementation, this would be fetched from a CMS and contain the full story.</p>
          </div>
          
          <TagLinks tags={newsItem.tags} />
        </div>
      </div>
      
      <div className="container" style={{ paddingBottom: '6rem' }}>
        <GiscusComments />
      </div>
    </>
  );
}
