import { retroArticles } from '@/lib/data';
import ArticleCard from '@/components/ArticleCard';
import { RetroArticle } from '@/lib/data';

export default function ArticlesPage() {
    return (
        <div className="container page-container">
            <h1 className="page-title">All Articles</h1>
            <div className="content-grid">
                {retroArticles.map((article: RetroArticle) => (
                    <ArticleCard key={article.id} article={article} isRetro />
                ))}
            </div>
        </div>
    );
}