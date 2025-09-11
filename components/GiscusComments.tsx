'use client';
import Giscus from '@giscus/react';
import { useTheme } from 'next-themes';
import { useSession, signIn } from 'next-auth/react';
import { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
const GiscusComments = () => {
    // CORRECTED: 'resolvedTheme' is no longer needed since we use the custom CSS file.
    useTheme();
    const { status } = useSession();
    const [mounted, setMounted] = useState(false);
    useEffect(() => {
        setMounted(true);
    }, []);
    const siteUrl = process.env.NEXT_PUBLIC_SITE_URL;
    // We now ONLY use our custom theme URL.
    const giscusTheme = siteUrl ? `${siteUrl}/css/giscus-theme.css` : 'transparent_dark';
    const repo = process.env.NEXT_PUBLIC_GISCUS_REPO;
    const repoId = process.env.NEXT_PUBLIC_GISCUS_REPO_ID;
    const category = process.env.NEXT_PUBLIC_GISCUS_CATEGORY;
    const categoryId = process.env.NEXT_PUBLIC_GISCUS_CATEGORY_ID;
    if (!repo || !repoId || !category || !categoryId) {
        console.error("Giscus environment variables are not configured in .env.local");
        return <p>Comment system is not configured.</p>;
    }
    const containerVariants = {
        hidden: { opacity: 0, y: 20 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
    };
    return (
        <motion.div
            className="comments-section"
            initial="hidden"
            animate="visible"
            variants={containerVariants}
        >
             <h2 className="section-title">Community Discussion</h2>
             {(!mounted || status === 'loading') && (
                <div className="comment-signin-prompt" style={{ height: '200px', background: 'var(--bg-secondary)', animation: 'pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite' }}>
                </div>
             )}
             {mounted && status === 'unauthenticated' && (
                <div className="comment-signin-prompt">
                    <h3>Join the Conversation</h3>
                    <p>Sign in with your GitHub account to leave a comment.</p>
                    <button onClick={() => signIn('github')} className="auth-button">
                        Sign In with GitHub
                    </button>
                </div>
             )}
             {mounted && status === 'authenticated' && (
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
                    theme={giscusTheme}
                    lang="en"
                    loading="lazy"
                />
             )}
        </motion.div>
    );
};
export default GiscusComments;
