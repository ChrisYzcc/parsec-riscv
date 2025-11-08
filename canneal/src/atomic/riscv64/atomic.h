#ifndef _MACHINE_ATOMIC_H_
#define _MACHINE_ATOMIC_H_

/*
 * RISC-V 64 原子操作实现
 * 说明：
 * - 使用 GCC __atomic 内建函数提供原子性和内存序，避免依赖特定汇编。
 * - 与 amd64 版本的接口保持一致：
 *   atomic_set_*, atomic_clear_*, atomic_add_*, atomic_subtract_* 返回 void
 *   atomic_cmpset_* 返回非 0 表示成功，0 表示失败
 *   atomic_fetchadd_int/atomic_fetchsubtract_int 返回操作前的旧值
 *   atomic_load_acq_* /atomic_store_rel_* 提供获取/释放语义
 *   atomic_readandclear_* 返回旧值并写 0
 */

#ifndef __has_builtin
#  define __has_builtin(x) 0
#endif

/* 基础二元操作（按位或、按位与、加、减），使用“放宽”内存序与 amd64 行为一致 */
#define ATOMIC_DEFINE_BINOP(name, type, builtin, xform)                     \
static __inline void                                                        \
atomic_##name##_##type(volatile u_##type *p, u_##type v)                    \
{                                                                           \
    (void)__atomic_##builtin((volatile u_##type *)p, (xform), __ATOMIC_RELAXED); \
}

/* set/clear/add/sub */
ATOMIC_DEFINE_BINOP(set,      char,  fetch_or,  v)
ATOMIC_DEFINE_BINOP(clear,    char,  fetch_and, (u_char)~v)
ATOMIC_DEFINE_BINOP(add,      char,  fetch_add, v)
ATOMIC_DEFINE_BINOP(subtract, char,  fetch_sub, v)

ATOMIC_DEFINE_BINOP(set,      short, fetch_or,  v)
ATOMIC_DEFINE_BINOP(clear,    short, fetch_and, (u_short)~v)
ATOMIC_DEFINE_BINOP(add,      short, fetch_add, v)
ATOMIC_DEFINE_BINOP(subtract, short, fetch_sub, v)

ATOMIC_DEFINE_BINOP(set,      int,   fetch_or,  v)
ATOMIC_DEFINE_BINOP(clear,    int,   fetch_and, (u_int)~v)
ATOMIC_DEFINE_BINOP(add,      int,   fetch_add, v)
ATOMIC_DEFINE_BINOP(subtract, int,   fetch_sub, v)

ATOMIC_DEFINE_BINOP(set,      long,  fetch_or,  v)
ATOMIC_DEFINE_BINOP(clear,    long,  fetch_and, (u_long)~v)
ATOMIC_DEFINE_BINOP(add,      long,  fetch_add, v)
ATOMIC_DEFINE_BINOP(subtract, long,  fetch_sub, v)

#undef ATOMIC_DEFINE_BINOP

/* 比较并交换：成功返回非 0，失败返回 0 */
static __inline int
atomic_cmpset_int(volatile u_int *dst, u_int exp, u_int src)
{
    return __atomic_compare_exchange_n(dst, &exp, src,
                                       0 /* strong */,
                                       __ATOMIC_ACQ_REL,
                                       __ATOMIC_ACQUIRE);
}

static __inline int
atomic_cmpset_long(volatile u_long *dst, u_long exp, u_long src)
{
    return __atomic_compare_exchange_n(dst, &exp, src,
                                       0 /* strong */,
                                       __ATOMIC_ACQ_REL,
                                       __ATOMIC_ACQUIRE);
}

/* fetch-add/sub：返回操作前旧值 */
static __inline u_int
atomic_fetchadd_int(volatile u_int *p, u_int v)
{
    return __atomic_fetch_add(p, v, __ATOMIC_ACQ_REL);
}

static __inline u_int
atomic_fetchsubtract_int(volatile u_int *p, int v)
{
    return __atomic_fetch_sub(p, (u_int)v, __ATOMIC_ACQ_REL);
}

/* 带获取/释放语义的加载/存储 */
#define ATOMIC_STORE_LOAD(TYPE)                                             \
static __inline u_##TYPE                                                    \
atomic_load_acq_##TYPE(volatile u_##TYPE *p)                                \
{                                                                           \
    return __atomic_load_n(p, __ATOMIC_ACQUIRE);                            \
}                                                                           \
static __inline void                                                        \
atomic_store_rel_##TYPE(volatile u_##TYPE *p, u_##TYPE v)                   \
{                                                                           \
    __atomic_store_n(p, v, __ATOMIC_RELEASE);                               \
}

ATOMIC_STORE_LOAD(char)
ATOMIC_STORE_LOAD(short)
ATOMIC_STORE_LOAD(int)
ATOMIC_STORE_LOAD(long)

#undef ATOMIC_STORE_LOAD

/* 读出当前值并清零，返回旧值 */
static __inline u_int
atomic_readandclear_int(volatile u_int *addr)
{
    return __atomic_exchange_n(addr, 0u, __ATOMIC_ACQ_REL);
}

static __inline u_long
atomic_readandclear_long(volatile u_long *addr)
{
    return __atomic_exchange_n(addr, 0ul, __ATOMIC_ACQ_REL);
}

/* Acquire/Release 变体与基本操作等价（与 amd64 文件保持一致） */
#define atomic_set_acq_char        atomic_set_char
#define atomic_set_rel_char        atomic_set_char
#define atomic_clear_acq_char      atomic_clear_char
#define atomic_clear_rel_char      atomic_clear_char
#define atomic_add_acq_char        atomic_add_char
#define atomic_add_rel_char        atomic_add_char
#define atomic_subtract_acq_char   atomic_subtract_char
#define atomic_subtract_rel_char   atomic_subtract_char

#define atomic_set_acq_short       atomic_set_short
#define atomic_set_rel_short       atomic_set_short
#define atomic_clear_acq_short     atomic_clear_short
#define atomic_clear_rel_short     atomic_clear_short
#define atomic_add_acq_short       atomic_add_short
#define atomic_add_rel_short       atomic_add_short
#define atomic_subtract_acq_short  atomic_subtract_short
#define atomic_subtract_rel_short  atomic_subtract_short

#define atomic_set_acq_int         atomic_set_int
#define atomic_set_rel_int         atomic_set_int
#define atomic_clear_acq_int       atomic_clear_int
#define atomic_clear_rel_int       atomic_clear_int
#define atomic_add_acq_int         atomic_add_int
#define atomic_add_rel_int         atomic_add_int
#define atomic_subtract_acq_int    atomic_subtract_int
#define atomic_subtract_rel_int    atomic_subtract_int
#define atomic_cmpset_acq_int      atomic_cmpset_int
#define atomic_cmpset_rel_int      atomic_cmpset_int

#define atomic_set_acq_long        atomic_set_long
#define atomic_set_rel_long        atomic_set_long
#define atomic_clear_acq_long      atomic_clear_long
#define atomic_clear_rel_long      atomic_clear_long
#define atomic_add_acq_long        atomic_add_long
#define atomic_add_rel_long        atomic_add_long
#define atomic_subtract_acq_long   atomic_subtract_long
#define atomic_subtract_rel_long   atomic_subtract_long
#define atomic_cmpset_acq_long     atomic_cmpset_long
#define atomic_cmpset_rel_long     atomic_cmpset_long

/* 按宽度别名（与 amd64 一致） */
/* 8-bit */
#define atomic_set_8               atomic_set_char
#define atomic_set_acq_8           atomic_set_acq_char
#define atomic_set_rel_8           atomic_set_rel_char
#define atomic_clear_8             atomic_clear_char
#define atomic_clear_acq_8         atomic_clear_acq_char
#define atomic_clear_rel_8         atomic_clear_rel_char
#define atomic_add_8               atomic_add_char
#define atomic_add_acq_8           atomic_add_acq_char
#define atomic_add_rel_8           atomic_add_rel_char
#define atomic_subtract_8          atomic_subtract_char
#define atomic_subtract_acq_8      atomic_subtract_acq_char
#define atomic_subtract_rel_8      atomic_subtract_rel_char
#define atomic_load_acq_8          atomic_load_acq_char
#define atomic_store_rel_8         atomic_store_rel_char

/* 16-bit */
#define atomic_set_16              atomic_set_short
#define atomic_set_acq_16          atomic_set_acq_short
#define atomic_set_rel_16          atomic_set_rel_short
#define atomic_clear_16            atomic_clear_short
#define atomic_clear_acq_16        atomic_clear_acq_short
#define atomic_clear_rel_16        atomic_clear_rel_short
#define atomic_add_16              atomic_add_short
#define atomic_add_acq_16          atomic_add_acq_short
#define atomic_add_rel_16          atomic_add_rel_short
#define atomic_subtract_16         atomic_subtract_short
#define atomic_subtract_acq_16     atomic_subtract_acq_short
#define atomic_subtract_rel_16     atomic_subtract_rel_short
#define atomic_load_acq_16         atomic_load_acq_short
#define atomic_store_rel_16        atomic_store_rel_short

/* 32-bit */
#define atomic_set_32              atomic_set_int
#define atomic_set_acq_32          atomic_set_acq_int
#define atomic_set_rel_32          atomic_set_rel_int
#define atomic_clear_32            atomic_clear_int
#define atomic_clear_acq_32        atomic_clear_acq_int
#define atomic_clear_rel_32        atomic_clear_rel_int
#define atomic_add_32              atomic_add_int
#define atomic_add_acq_32          atomic_add_acq_int
#define atomic_add_rel_32          atomic_add_rel_int
#define atomic_subtract_32         atomic_subtract_int
#define atomic_subtract_acq_32     atomic_subtract_acq_int
#define atomic_subtract_rel_32     atomic_subtract_rel_int
#define atomic_load_acq_32         atomic_load_acq_int
#define atomic_store_rel_32        atomic_store_rel_int
#define atomic_cmpset_32           atomic_cmpset_int
#define atomic_cmpset_acq_32       atomic_cmpset_acq_int
#define atomic_cmpset_rel_32       atomic_cmpset_rel_int
#define atomic_readandclear_32     atomic_readandclear_int
#define atomic_fetchadd_32         atomic_fetchadd_int
#define atomic_fetchsubtract_32    atomic_fetchsubtract_int

/* 64-bit */
#define atomic_set_64              atomic_set_long
#define atomic_set_acq_64          atomic_set_acq_long
#define atomic_set_rel_64          atomic_set_rel_long
#define atomic_clear_64            atomic_clear_long
#define atomic_clear_acq_64        atomic_clear_acq_long
#define atomic_clear_rel_64        atomic_clear_rel_long
#define atomic_add_64              atomic_add_long
#define atomic_add_acq_64          atomic_add_acq_long
#define atomic_add_rel_64          atomic_add_rel_long
#define atomic_subtract_64         atomic_subtract_long
#define atomic_subtract_acq_64     atomic_subtract_acq_long
#define atomic_subtract_rel_64     atomic_subtract_rel_long
#define atomic_load_acq_64         atomic_load_acq_long
#define atomic_store_rel_64        atomic_store_rel_long
#define atomic_cmpset_64           atomic_cmpset_long
#define atomic_cmpset_acq_64       atomic_cmpset_acq_long
#define atomic_cmpset_rel_64       atomic_cmpset_rel_long
#define atomic_readandclear_64     atomic_readandclear_long

/* 指针操作基于 long */
#define atomic_set_ptr             atomic_set_long
#define atomic_set_acq_ptr         atomic_set_acq_long
#define atomic_set_rel_ptr         atomic_set_rel_long
#define atomic_clear_ptr           atomic_clear_long
#define atomic_clear_acq_ptr       atomic_clear_acq_long
#define atomic_clear_rel_ptr       atomic_clear_rel_long
#define atomic_add_ptr             atomic_add_long
#define atomic_add_acq_ptr         atomic_add_acq_long
#define atomic_add_rel_ptr         atomic_add_rel_long
#define atomic_subtract_ptr        atomic_subtract_long
#define atomic_subtract_acq_ptr    atomic_subtract_acq_long
#define atomic_subtract_rel_ptr    atomic_subtract_rel_long
#define atomic_load_acq_ptr        atomic_load_acq_long
#define atomic_store_rel_ptr       atomic_store_rel_long
#define atomic_cmpset_ptr          atomic_cmpset_long
#define atomic_cmpset_acq_ptr      atomic_cmpset_acq_long
#define atomic_cmpset_rel_ptr      atomic_cmpset_rel_long
#define atomic_readandclear_ptr    atomic_readandclear_long

#endif /* _MACHINE_ATOMIC_H_ */