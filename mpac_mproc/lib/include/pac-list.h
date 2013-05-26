struct list_head  {
	struct list_head *next, *prev;
};

static __inline__ void __list_add(struct list_head * new_list,
    struct list_head * prev,
    struct list_head * next)
{
	next->prev = new_list;
	new_list->next = next;
	new_list->prev = prev;
	prev->next = new_list;
}

static __inline__ void list_add_tail(struct list_head *new_list, struct list_head *head)
{
    __list_add(new_list, head->prev, head);
}

static __inline__ void list_add(struct list_head *new_list, struct list_head *head)
{
    __list_add(new_list, head, head->next);
}


#define INIT_LIST_HEAD(ptr) do { \
    (ptr)->next = (ptr); (ptr)->prev = (ptr); \
} while (0)

/*
 * Delete a list entry by making the prev/next entries
 * point to each other.
 *
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 */
static __inline__ void __list_del(struct list_head * prev,
				  struct list_head * next)
{
	next->prev = prev;
	prev->next = next;
}

static __inline__ void list_del(struct list_head *entry)
{
	__list_del(entry->prev, entry->next);
}

static __inline__ int list_empty(struct list_head *head)
{
	return head->next == head;
}

/*
 * Splice in "list" into "head"
 */
static __inline__ void list_splice(struct list_head *list, struct list_head *head)
{
	struct list_head *first = list->next;

	if (first != list) {
		struct list_head *last = list->prev;
		struct list_head *at = head->next;

		first->prev = head;
		head->next = first;

		last->next = at;
		at->prev = last;
	}
}

#define list_entry(ptr, type, member) \
	((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))

#define list_for_each(pos, head) \
	for (pos = (head)->next; pos != (head); pos = pos->next)

#define list_for_each_safe(pos, n, head) \
	for (pos = (head)->next, n = pos->next; pos != (head); \
		pos = n, n = pos->next)

#define list_for_each_entry(pos, head, member)				\
	for (pos = list_entry((head)->next, typeof(*pos), member);	\
	     &pos->member != (head); 	\
	     pos = list_entry(pos->member.next, typeof(*pos), member))

