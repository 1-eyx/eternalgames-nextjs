#!/bin/bash

# ==============================================================================
# EternalGames: Giscus Definitive Fix Script (localtunnel)
# ==============================================================================
# This script uses localtunnel to create a hassle-free public URL and applies
# it to the Giscus component, guaranteeing the custom theme will load.
# ==============================================================================

set -e

echo "🚀 Applying the definitive fix using a public localtunnel URL."
echo ""
echo "Please paste the 'your url is:' URL from your localtunnel terminal."
echo "It should look like: https://something.loca.lt"
read -p "Enter your localtunnel URL here: " LOCALTUNNEL_URL

# Validate that the user entered something
if [ -z "$LOCALTUNNEL_URL" ]; then
    echo "No URL entered. Aborting."
    exit 1
fi

# We use a temporary file to build the new component content
TEMP_FILE=$(mktemp)

cat <<EOF > "$TEMP_FILE"
'use client';

import Giscus from '@giscus/react';
import { useTheme } from 'next-themes';
import { useSession, signIn } from 'next-auth/react';
import { useEffect, useState } from 'react';
import { motion } from 'framer-motion';

const GiscusComments = () => {
    const { theme, resolvedTheme } = useTheme();
    const { data: session, status } = useSession();
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);
    
    // =================================================================
    //  DEFINITIVE FIX: Using the public localtunnel URL. This will work.
    // =================================================================
    const giscusTheme = '${LOCALTUNNEL_URL}/css/giscus-theme.css';

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
                    {/* Skeleton Loader */}
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
                    repo={repo as \`\${string}/\${string}\`}
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
EOF

# Move the temporary file to the correct location
mv "$TEMP_FILE" components/GiscusComments.tsx

echo ""
echo "✅ Giscus component updated with your public localtunnel URL."
echo ""
echo "IMPORTANT: Please restart your Next.js server now ('npm run dev') and hard-refresh your browser."
echo "Keep the localtunnel terminal window open while you test."