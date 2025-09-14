'use client';
import Giscus from '@giscus/react';
import { useTheme } from 'next-themes';
import { useSession, signIn } from 'next-auth/react';
import { useEffect, useState } from 'react';

const GiscusComments = () => {
    const { resolvedTheme } = useTheme();
    const { status } = useSession();
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);

    const repo = process.env.NEXT_PUBLIC_GISCUS_REPO;
    const repoId = process.env.NEXT_PUBLIC_GISCUS_REPO_ID;
    const category = process.env.NEXT_PUBLIC_GISCUS_CATEGORY;
    const categoryId = process.env.NEXT_PUBLIC_GISCUS_CATEGORY_ID;

    // We must delay rendering until the component is mounted to ensure the theme is accurate.
    if (!mounted) {
        return (
            <div className="comments-section">
                <h2 className="section-title">Community Discussion</h2>
                <div className="comment-signin-prompt" style={{ height: '200px', background: 'var(--bg-secondary)', animation: 'pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite' }}></div>
            </div>
        );
    }

    if (!repo || !repoId || !category || !categoryId) {
        return <p>Comment system is not configured.</p>;
    }
    
    return (
        <div className="comments-section">
             <h2 className="section-title">Community Discussion</h2>
             
             {status === 'unauthenticated' && (
                <div className="comment-signin-prompt">
                    <h3>Join the Conversation</h3>
                    <p>Sign in with your GitHub account to leave a comment.</p>
                    <button onClick={() => signIn('github')} className="auth-button">
                        Sign In with GitHub
                    </button>
                </div>
             )}

             {status === 'authenticated' && (
                <Giscus
                    id="comments"
                    repo={repo as `${string}/${string}`}
                    repoId={repoId}
                    category={category}
                    categoryId={categoryId}
                    mapping="pathname"
                    reactionsEnabled="1"
                    emitMetadata="0"
                    inputPosition="top"
                    // Reverted to Giscus's simple, built-in theme handling. This will work.
                    theme={resolvedTheme === 'dark' ? 'dark' : 'light'}
                    lang="en"
                    loading="lazy"
                />
             )}
        </div>
    );
};

export default GiscusComments;
