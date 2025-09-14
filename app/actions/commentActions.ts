'use server';

import prisma from '@/lib/prisma';
import { authOptions } from '@/app/api/auth/[...nextauth]/route';
import { getServerSession } from 'next-auth';
import { revalidatePath } from 'next/cache';

export async function postComment(contentSlug: string, content: string) {
    const session = await getServerSession(authOptions);

    if (!session?.user?.id) {
        throw new Error('You must be signed in to comment.');
    }

    if (!content || content.trim().length === 0) {
        throw new Error('Comment cannot be empty.');
    }

    try {
        await prisma.comment.create({
            data: {
                contentSlug: contentSlug,
                content: content,
                authorId: session.user.id,
            },
        });

        // Revalidate the page to show the new comment immediately
        // We will revalidate the generic layout path to cover all article types
        revalidatePath('/', 'layout');
    } catch (error) {
        console.error("Failed to post comment:", error);
        throw new Error('Something went wrong. Could not post comment.');
    }
}
