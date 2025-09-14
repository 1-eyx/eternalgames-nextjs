import prisma from '@/lib/prisma';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';
import CommentForm from './CommentForm';
import Image from 'next/image';

const SignInPrompt = () => (
    <div className="comment-signin-prompt">
        <h3>Join the Conversation</h3>
        <p>Sign in to your EternalGames account to leave a comment.</p>
        <a href="/api/auth/signin" className="auth-button">
            Sign In
        </a>
    </div>
);

export default async function CustomComments({ slug }: { slug: string }) {
    const session = await getServerSession(authOptions);

    const comments = await prisma.comment.findMany({
        where: { contentSlug: slug },
        include: { author: true },
        orderBy: { createdAt: 'desc' },
    });

    return (
        <div className="comments-section">
            <h2 className="section-title">Community Discussion</h2>
            {session?.user ? <CommentForm slug={slug} /> : <SignInPrompt />}
            
            <div className="comment-list">
                {comments.map(comment => (
                    <div key={comment.id} className="comment">
                        <div className="comment-author">
                            <Image src={comment.author.image || ''} alt={comment.author.name || ''} width={32} height={32} className="user-avatar" />
                            <span>{comment.author.name}</span>
                        </div>
                        <p className="comment-content">{comment.content}</p>
                    </div>
                ))}
            </div>
        </div>
    );
}
