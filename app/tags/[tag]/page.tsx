import { allContent } from '@/lib/data';
import { notFound } from 'next/navigation';
import Image from 'next/image';
import ArticleCard from '@/components/ArticleCard';
import { Review, RetroArticle, NewsItem } from '@/lib/data';

type TagPageProps = { params: { tag: string; }; };

const isReview = (item: any): item is Review => item.type === 'review';
const isRetroArticle = (item: any): item is RetroArticle => item.type === 'archive';

export default function TagPage({ params }: TagPageProps) {
  const tagName = decodeURIComponent(params.tag);
  const taggedContent = allContent.filter(item => 
    item.tags.some(t => t.toLowerCase() === tagName.toLowerCase())
  );

  if (taggedContent.length === 0) {
    notFound();
  }

  // Capitalize the first letter for the title
  const displayTagName = tagName.charAt(0).toUpperCase() + tagName.slice(1);

  return (
    <div className="container page-container">
      <h1 className="page-title">Content tagged with "{displayTagName}"</h1>
      <div className="content-grid">
        {taggedContent.map(item => {
            if (isReview(item) || isRetroArticle(item)) {
                return <ArticleCard key={`${item.type}-${item.id}`} article={item} isRetro={isRetroArticle(item)} />;
            }
            if (item.type === 'news') {
                const newsItem = item as NewsItem;
                // We need to use the full NewsCard component here
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
