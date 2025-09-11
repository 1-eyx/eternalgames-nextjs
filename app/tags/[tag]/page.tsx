import { allContent } from '@/lib/data';
import { notFound } from 'next/navigation';
import ArticleCard from '@/components/ArticleCard';
import { Review, RetroArticle, NewsItem } from '@/lib/data';
import Image from 'next/image';

type TagPageProps = { params: { tag: string; }; };

// CORRECTED: Replaced 'any' with a more specific object type.
const isReview = (item: { type: string }): item is Review => item.type === 'review';
const isRetroArticle = (item: { type: string }): item is RetroArticle => item.type === 'archive';

export default function TagPage({ params }: TagPageProps) {
  const tagName = decodeURIComponent(params.tag);
  const taggedContent = allContent.filter(item => 
    item.tags.some(t => t.toLowerCase() === tagName.toLowerCase())
  );

  if (taggedContent.length === 0) {
    notFound();
  }

  const displayTagName = tagName.charAt(0).toUpperCase() + tagName.slice(1);

  return (
    <div className="container page-container">
      {/* CORRECTED: Escaped quotes */}
      <h1 className="page-title">Content tagged with &quot;{displayTagName}&quot;</h1>
      <div className="content-grid">
        {taggedContent.map(item => {
            if (isReview(item) || isRetroArticle(item)) {
                return <ArticleCard key={`${item.type}-${item.id}`} article={item} isRetro={isRetroArticle(item)} />;
            }
            if (item.type === 'news') {
                const newsItem = item as NewsItem;
                return (
                    <div key={`${item.type}-${item.id}`} className="news-card">
                        <div className="news-card-image-container">
                            <Image src={newsItem.imageUrl} alt={newsItem.title} fill style={{objectFit: 'cover'}} className="news-card-image" />
                        </div>
                        <div className="news-card-content">
                            <p className="news-card-category">{newsItem.category}</p>
                            <h3>{newsItem.title}</h3>
                        </div>
                    </div>
                )
            }
            return null;
        })}
      </div>
    </div>
  );
}
