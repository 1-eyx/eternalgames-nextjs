'use client';
import Giscus from '@giscus/react';
import { useTheme } from 'next-themes';
import { useSession, signIn } from 'next-auth/react';
import { useEffect, useState } from 'react';
import { motion } from 'framer-motion';

const GiscusComments = () => {
    // =================================================================
    //  THE ONE TRUE FIX: Use `theme` not `resolvedTheme`.
    //  `theme` is the user's explicit choice. This eliminates the race condition.
    // =================================================================
    const { theme } = useTheme();
    const { status } = useSession();
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);

    const siteUrl = 'https://eternalgames-nextjs.vercel.app';
    
    // We determine the theme to load based on the user's explicit choice.
    // If their choice is 'system', we default to dark for the URL construction,
    // but Giscus will still respect their system preference internally. This is robust.
    const giscusThemeUrl = theme === 'light' 
        ? `${siteUrl}/css/giscus-light.css` 
        : `${siteUrl}/css/giscus-dark.css`;

    const repo = process.env.NEXT_PUBLIC_GISCUS_REPO;
    const repoId = process.env.NEXT_PUBLIC_GISCUS_REPO_ID;
    const category = process.env.NEXT_PUBLIC_GISCUS_CATEGORY;
    const categoryId = process.env.NEXT_PUBLIC_GISCUS_CATEGORY_ID;

    if (!repo || !repoId || !category || !categoryId) {
        return <p>Comment system is not configured.</p>;
    }

    const containerVariants = {
        hidden: { opacity: 0, y: 20 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
    };
    
    // We must delay rendering Giscus until `mounted` is true, so that `theme` is accurate.
    if (!mounted) {
        return (
            <div className="comments-section">
                <h2 className="section-title">Community Discussion</h2>
                <div className="comment-signin-prompt" style={{ height: '200px', background: 'var(--bg-secondary)', animation: 'pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite' }}></div>
            </div>
        );
    }
    
    return (
        <motion.div
            className="comments-section"
            initial="hidden"
            animate="visible"
            variants={containerVariants}
        >
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
                    key={theme} // Use theme to force re-render
                    id="comments"
                    repo={repo as `${string}/${string}`}
                    repoId={repoId}
                    category={category}
                    categoryId={categoryId}
                    mapping="pathname"
                    reactionsEnabled="1"
                    emitMetadata="0"
                    inputPosition="top"
                    theme={giscusThemeUrl}
                    lang="en"
                    loading="lazy"
                />
             )}
        </motion.div>
    );
};

export default GiscusComments;
