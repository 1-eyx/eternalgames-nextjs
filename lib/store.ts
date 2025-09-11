import { create } from 'zustand';
import { persist } from 'zustand/middleware';

type UserState = {
  bookmarks: number[];
  readingHistory: number[];
};

type UserActions = {
  toggleBookmark: (articleId: number) => void;
  addVisit: (articleId: number) => void;
  clearHistory: () => void;
};

export const useUserStore = create<UserState & UserActions>()(
  persist(
    (set, get) => ({
      bookmarks: [],
      readingHistory: [],
      toggleBookmark: (articleId) => {
        const currentBookmarks = get().bookmarks;
        const isBookmarked = currentBookmarks.includes(articleId);
        const newBookmarks = isBookmarked
          ? currentBookmarks.filter((id) => id !== articleId)
          : [...currentBookmarks, articleId];
        set({ bookmarks: newBookmarks });
      },
      addVisit: (articleId) => {
        const currentHistory = get().readingHistory;
        const newHistory = [articleId, ...currentHistory.filter((id) => id !== articleId)];
        const trimmedHistory = newHistory.slice(0, 50); // Keep history to a reasonable size
        set({ readingHistory: trimmedHistory });
      },
      clearHistory: () => {
        set({ readingHistory: [] });
      },
    }),
    {
      name: 'eternalgames-user-preferences', // The key in localStorage
    }
  )
);
