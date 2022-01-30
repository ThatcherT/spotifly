--
-- PostgreSQL database dump
--

-- Dumped from database version 12.0
-- Dumped by pg_dump version 12.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO thatcher;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO thatcher;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO thatcher;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO thatcher;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO thatcher;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO thatcher;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO thatcher;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO thatcher;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO thatcher;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO thatcher;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO thatcher;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO thatcher;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO thatcher;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO thatcher;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO thatcher;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO thatcher;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO thatcher;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO thatcher;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO thatcher;

--
-- Name: queueing_follower; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.queueing_follower (
    id integer NOT NULL,
    number character varying(10) NOT NULL,
    following character varying(50) NOT NULL,
    following_spotify_id character varying(100),
    promo boolean NOT NULL
);


ALTER TABLE public.queueing_follower OWNER TO thatcher;

--
-- Name: queueing_follower_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.queueing_follower_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.queueing_follower_id_seq OWNER TO thatcher;

--
-- Name: queueing_follower_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.queueing_follower_id_seq OWNED BY public.queueing_follower.id;


--
-- Name: queueing_listener; Type: TABLE; Schema: public; Owner: thatcher
--

CREATE TABLE public.queueing_listener (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    token text,
    created_at timestamp with time zone NOT NULL,
    spotify_id character varying(100),
    email character varying(254),
    number character varying(10),
    expires_at text,
    refresh_token text,
    max_offset integer NOT NULL
);


ALTER TABLE public.queueing_listener OWNER TO thatcher;

--
-- Name: queueing_listener_id_seq; Type: SEQUENCE; Schema: public; Owner: thatcher
--

CREATE SEQUENCE public.queueing_listener_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.queueing_listener_id_seq OWNER TO thatcher;

--
-- Name: queueing_listener_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: thatcher
--

ALTER SEQUENCE public.queueing_listener_id_seq OWNED BY public.queueing_listener.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: queueing_follower id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_follower ALTER COLUMN id SET DEFAULT nextval('public.queueing_follower_id_seq'::regclass);


--
-- Name: queueing_listener id; Type: DEFAULT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_listener ALTER COLUMN id SET DEFAULT nextval('public.queueing_listener_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add follower	1	add_follower
2	Can change follower	1	change_follower
3	Can delete follower	1	delete_follower
4	Can view follower	1	view_follower
5	Can add listener	2	add_listener
6	Can change listener	2	change_listener
7	Can delete listener	2	delete_listener
8	Can view listener	2	view_listener
9	Can add log entry	3	add_logentry
10	Can change log entry	3	change_logentry
11	Can delete log entry	3	delete_logentry
12	Can view log entry	3	view_logentry
13	Can add permission	4	add_permission
14	Can change permission	4	change_permission
15	Can delete permission	4	delete_permission
16	Can view permission	4	view_permission
17	Can add group	5	add_group
18	Can change group	5	change_group
19	Can delete group	5	delete_group
20	Can view group	5	view_group
21	Can add user	6	add_user
22	Can change user	6	change_user
23	Can delete user	6	delete_user
24	Can view user	6	view_user
25	Can add content type	7	add_contenttype
26	Can change content type	7	change_contenttype
27	Can delete content type	7	delete_contenttype
28	Can view content type	7	view_contenttype
29	Can add session	8	add_session
30	Can change session	8	change_session
31	Can delete session	8	delete_session
32	Can view session	8	view_session
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$260000$YnLtjqTJHvZ7WrJAmm6wT9$21SMPnJDu9dT+sdtvuyYIL92szoBvsgyjNlvERRmNUk=	2021-10-05 00:17:54.759673+00	t	thatcher				t	t	2021-08-24 16:51:14.999557+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2021-08-25 22:05:26.054055+00	13	Grant Gillespie	2	[]	2	1
2	2021-08-26 01:45:11.625982+00	6	8503462086 following nina staviski	1	[{"added": {}}]	1	1
3	2021-08-26 01:45:23.76524+00	6	8503462086 following nina staviski	2	[]	1	1
4	2021-08-26 02:09:15.194508+00	15	Julienne Svalander 	3		2	1
5	2021-08-26 13:34:15.354947+00	17	jedumo18	3		2	1
6	2021-08-26 13:34:44.68595+00	18	jedumo18	1	[{"added": {}}]	2	1
7	2021-08-30 01:21:20.75367+00	22	ethan	2	[]	2	1
8	2021-08-30 14:27:23.489196+00	26	Celink22	2	[]	2	1
9	2021-08-30 22:22:26.874021+00	1	thatcher	2	[{"changed": {"fields": ["Number"]}}]	2	1
10	2021-09-01 21:04:08.287732+00	28	Kendyll Gavras	2	[]	2	1
11	2021-09-09 21:01:19.020788+00	1	thatcher	2	[{"changed": {"fields": ["Number"]}}]	2	1
12	2021-09-14 16:12:59.671034+00	39	joewcozby	2	[]	2	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	queueing	follower
2	queueing	listener
3	admin	logentry
4	auth	permission
5	auth	group
6	auth	user
7	contenttypes	contenttype
8	sessions	session
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2021-08-24 16:50:47.288184+00
2	auth	0001_initial	2021-08-24 16:50:47.392041+00
3	admin	0001_initial	2021-08-24 16:50:47.423139+00
4	admin	0002_logentry_remove_auto_add	2021-08-24 16:50:47.433901+00
5	admin	0003_logentry_add_action_flag_choices	2021-08-24 16:50:47.444043+00
6	contenttypes	0002_remove_content_type_name	2021-08-24 16:50:47.463515+00
7	auth	0002_alter_permission_name_max_length	2021-08-24 16:50:47.475191+00
8	auth	0003_alter_user_email_max_length	2021-08-24 16:50:47.486141+00
9	auth	0004_alter_user_username_opts	2021-08-24 16:50:47.498077+00
10	auth	0005_alter_user_last_login_null	2021-08-24 16:50:47.508317+00
11	auth	0006_require_contenttypes_0002	2021-08-24 16:50:47.511307+00
12	auth	0007_alter_validators_add_error_messages	2021-08-24 16:50:47.521079+00
13	auth	0008_alter_user_username_max_length	2021-08-24 16:50:47.53556+00
14	auth	0009_alter_user_last_name_max_length	2021-08-24 16:50:47.546357+00
15	auth	0010_alter_group_name_max_length	2021-08-24 16:50:47.557476+00
16	auth	0011_update_proxy_permissions	2021-08-24 16:50:47.567319+00
17	auth	0012_alter_user_first_name_max_length	2021-08-24 16:50:47.578115+00
18	queueing	0001_initial	2021-08-24 16:50:47.617885+00
19	queueing	0002_alter_listener_number	2021-08-24 16:50:47.648816+00
20	queueing	0003_alter_follower_following	2021-08-24 16:50:47.662057+00
21	queueing	0004_alter_follower_number	2021-08-24 16:50:47.67579+00
22	queueing	0005_listener_spotify_id	2021-08-24 16:50:47.692189+00
23	queueing	0006_auto_20210728_0348	2021-08-24 16:50:47.699857+00
24	queueing	0007_alter_follower_following	2021-08-24 16:50:47.706321+00
25	queueing	0008_auto_20210728_0425	2021-08-24 16:50:47.772628+00
26	queueing	0009_remove_listener_number	2021-08-24 16:50:47.781243+00
27	queueing	0010_alter_listener_token	2021-08-24 16:50:47.791884+00
28	queueing	0011_alter_listener_token	2021-08-24 16:50:47.800441+00
29	queueing	0012_auto_20210822_1953	2021-08-24 16:50:47.807633+00
30	queueing	0013_listener_number	2021-08-24 16:50:47.821229+00
31	sessions	0001_initial	2021-08-24 16:50:47.842907+00
32	queueing	0014_auto_20210825_1921	2021-08-25 22:02:38.81762+00
33	queueing	0015_rename_expires_in_listener_expires_at	2021-08-25 22:02:38.825245+00
34	queueing	0016_auto_20210830_2223	2021-08-30 22:27:38.313108+00
35	queueing	0017_listener_max_offset	2021-09-09 21:00:08.5866+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
fc8v26p6okjnusylxvko27xq1xn2nh8f	.eJxVjEsOwjAMBe-SNYpiGrcNS_Y9Q2UnNimgROpnhbg7VOoCtm9m3suMtK153BaZxymZiwFz-t2Y4kPKDtKdyq3aWMs6T2x3xR50sUNN8rwe7t9BpiV_a4cdt9CefUAlTCrc-xag0cYpUGAU3wtL0E4dqsaU-oDcgKoDiozm_QHk9Tia:1mIZe1:CTy0L3tI2mi-Dhbr5cOCFj6XSGm6qwX3dLvV-jVpQoA	2021-09-07 16:51:25.104357+00
egp6wt14z2pa0ndeeopllcr59rff4lwg	.eJxVjEsOwjAMBe-SNYpiGrcNS_Y9Q2UnNimgROpnhbg7VOoCtm9m3suMtK153BaZxymZiwFz-t2Y4kPKDtKdyq3aWMs6T2x3xR50sUNN8rwe7t9BpiV_a4cdt9CefUAlTCrc-xag0cYpUGAU3wtL0E4dqsaU-oDcgKoDiozm_QHk9Tia:1mMaXR:WMabLc4WqK05jOuF7MjJmoNge5sgQMB3S_Ls3t2atpc	2021-09-18 18:37:13.74529+00
uv9vbqfo0qs07186iuqnw9w07p8r6akc	.eJxVjEsOwjAMBe-SNYpiGrcNS_Y9Q2UnNimgROpnhbg7VOoCtm9m3suMtK153BaZxymZiwFz-t2Y4kPKDtKdyq3aWMs6T2x3xR50sUNN8rwe7t9BpiV_a4cdt9CefUAlTCrc-xag0cYpUGAU3wtL0E4dqsaU-oDcgKoDiozm_QHk9Tia:1mMajW:rHgiqCfLfv81Vy1IwWUfE0WwrbTWI4ViRMsKIFU74rw	2021-09-18 18:49:42.819622+00
247efv6lp5r7p92qe008jheho3cxhmi3	.eJxVjEsOwjAMBe-SNYpiGrcNS_Y9Q2UnNimgROpnhbg7VOoCtm9m3suMtK153BaZxymZiwFz-t2Y4kPKDtKdyq3aWMs6T2x3xR50sUNN8rwe7t9BpiV_a4cdt9CefUAlTCrc-xag0cYpUGAU3wtL0E4dqsaU-oDcgKoDiozm_QHk9Tia:1mORA0:lgTy7hUFX5iaCMYzxRNV7PF_J8idTIxHZGjkPINN2Sc	2021-09-23 21:00:40.333096+00
x9b5142knf8t0y0fpzapv8m924t5b2tr	.eJxVjEsOwjAMBe-SNYpiGrcNS_Y9Q2UnNimgROpnhbg7VOoCtm9m3suMtK153BaZxymZiwFz-t2Y4kPKDtKdyq3aWMs6T2x3xR50sUNN8rwe7t9BpiV_a4cdt9CefUAlTCrc-xag0cYpUGAU3wtL0E4dqsaU-oDcgKoDiozm_QHk9Tia:1mXY9a:8rPh5WT-SISOfzxc7C9FYhPuQwc3D9jjsjFSq0J5qks	2021-10-19 00:17:54.767491+00
\.


--
-- Data for Name: queueing_follower; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.queueing_follower (id, number, following, following_spotify_id, promo) FROM stdin;
3	7372754490	megan	\N	t
4	9132164075	hudson	\N	t
5	4692124220	thatcher	\N	t
7	7132032815	nina staviski	\N	t
8	2816601474	nina staviski	\N	t
6	8503462086	angelina ngo	\N	t
9	4694223110	rea	\N	t
10	2103259466	deseree rios	\N	t
1	7372754382	thatcher	\N	t
12	9032279602	deseree rios	\N	t
13	9728353567	thatcher	\N	t
14	2142984489	thatcher	\N	t
15	8175650590	thatcher	\N	t
11	4692365358	thatcher	\N	t
16	9728221233	thatcher	\N	t
17	8325255780	thatcher	\N	t
18	9725298937	thatcher	\N	t
19	8478493917	thatcher	\N	t
20	4699298085	thatcher	\N	t
21	2816737223	harry khuc	\N	f
22	8324036669	harry khuc	\N	f
23	8328182597	harry khuc	\N	f
24	2812586975	harry khuc	\N	f
25	8326436133	harry khuc	\N	f
26	2817776864	harry khuc	\N	f
27	5129401007	thatcher	\N	f
28	3012506184	thatcher	\N	f
29	2148647763	hunter chemelli	\N	f
2	4692519679	hunter chemelli	\N	t
\.


--
-- Data for Name: queueing_listener; Type: TABLE DATA; Schema: public; Owner: thatcher
--

COPY public.queueing_listener (id, name, token, created_at, spotify_id, email, number, expires_at, refresh_token, max_offset) FROM stdin;
27	jwolffey	\N	2021-08-30 05:25:58.729047+00	\N	jwolffey@gmail.com	T	\N	\N	5000
3	Kendyllgavras	\N	2021-08-24 17:00:57.97881+00	\N	Kendyllgavras@ou.edu	\N	\N	\N	5000
26	Celink22		2021-08-30 03:56:09.639031+00	\N	Celink22@gmail.com	3126082221			5000
5	Matt	\N	2021-08-24 17:29:21.6955+00	\N	Mattshuttleworth45@gmail.com	9728353567	\N	\N	5000
6	Phillip77478	\N	2021-08-24 21:40:00.029358+00	\N	Phillip77478@gmail.com	2819027115	\N	\N	5000
9	roly.maldo	\N	2021-08-24 22:15:27.19027+00	\N	roly.maldo@gmail.com	2102195557	\N	\N	5000
11	Senfish11	\N	2021-08-24 23:44:24.37558+00	\N	Senfish11@gmail.com	\N	\N	\N	5000
2	megan	BQBt6-KrjJoHg1Z1vyV7E6WkXm8zF8uP6HR7D5fWpJs62Apa4jxMf5c7P1ReQEvTNt8K2iwMKxUQgLBRQv7v-lnEVfdLXbegef-EB5BTxOJlWIbB4DM0D6HAY-vLRvfdLF4WJ8bTPPk0m_v0EIrSnrWno1xOqVMRrfJi9Gs	2021-08-24 16:55:58.947517+00	\N	meganm117@gmail.com	7372754490	1629933793	AQCyC9M_0NDU5silC9AoK3eOAxK6sDlyvbQqoRpYHpZv4h0JyhPZSvSkiBBaDBGeFsB16AYPJWOev53EY8Xub06w5hEwl5Y95XSMMdtQ1DOLSIVOezXfZTPiGbXGO6gN1yQ	5000
10	hudson	BQDwAObnUFUiuGkPGi730daemK5qkFfuT1B8fiFupcaNZmzq9JRNBzx74OWcH6P5v_oAH59MHMHtYJ0cWNvCC8mD49yUJaAyIqscprWqK6DNaWosFQkd9J2FOyOscn54woube-ujo7d4keIP8roxJUh5TPf51nBYt5HW6DY1KzmT	2021-08-24 22:22:59.686442+00	\N	hspencerdavis@gmail.com	9132164075	1629934435	AQCSeN_NcEZoQMPSNmoZe8cHnKZherv15fIEHu7NOqI7Qm2Zdg7tA7Na66UnIWc52PwdwnZAf6HLRKqGufHbYdqR-Eqix2SdiEX41qOQIHs7-J8loICNj_DFYzd6sPUI4mM	5000
8	tanner thornberry	BQA66teRnhUPnVqQWz45ncP22FtNtKkkqwm4U88kVm3pwFWwhQL4vkQ0M-P7r0E4ONlDs0bOB7F5Yp5kpqgZCBULohcDusZfNIOITR140h8j1nH8lgs9IE_V-YykXVG2BHvtLgz3DZMRv7pgyBTyJ7cl2QYRCM8Dm517kXr8ZpY	2021-08-24 22:11:07.651985+00	\N	Tjthornberry@gmail.com	4692124220	1629941130	AQDMGUjo-0sQ2k16czJ4INYZKfqa7dnChPrZGs-2JCkgPObqC9HGt9DYgAWB0FT6GocVAcQn5nBwvSrIGvSKJVHz3jjX_78vxHO7o3t4x0bMNHqpvkeVuLBOVEi_Czd0fZY	5000
13	grant gillespie	BQApyyZqIeFGxmJkJhjC8-cjsWkn4rlvSZqbMwGLDWCeEEOV23VbMT2ItrwXgLNjCd-snFLeoSRVA6LZclLsCH_hSDX7RyDJ0CNMUVlk-BPKnuesDewFB2dXmESJ6txwts-0h2zocJLRO9bwYTJdgiIbthNIIsJY73nna1Z0NNBfuQH8JcFo3FBNNqDp	2021-08-25 18:04:26.527735+00	\N	grantgillespie3@gmail.com	7132032815	1629949192	AQDu4YG7o9912R4TB8nQrPBl_FMC4icbrSfWGUpfqlZNwJBu0dxlAQzKdRgQjO2PuPWa7XZwbIIvAzxYISy1MwaLBTXgjowQSENZbFaOcz3TkyXn1TA6koMiDYyTeWYK29c	5000
16	angelina ngo	BQApyyZqIeFGxmJkJhjC8-cjsWkn4rlvSZqbMwGLDWCeEEOV23VbMT2ItrwXgLNjCd-snFLeoSRVA6LZclLsCH_hSDX7RyDJ0CNMUVlk-BPKnuesDewFB2dXmESJ6txwts-0h2zocJLRO9bwYTJdgiIbthNIIsJY73nna1Z0NNBfuQH8JcFo3FBNNqDp	2021-08-26 02:42:11.339503+00	\N	Angelinango3@ymail.com	2816601474	1629949192	AQDu4YG7o9912R4TB8nQrPBl_FMC4icbrSfWGUpfqlZNwJBu0dxlAQzKdRgQjO2PuPWa7XZwbIIvAzxYISy1MwaLBTXgjowQSENZbFaOcz3TkyXn1TA6koMiDYyTeWYK29c	5000
12	nina staviski	BQCrzKlXUcd5grLSe9lvVqvtIcKjqBXpsjiu4DQ2tbNqi1wTyRA_sd_CyBhUDNQ3dvCx265d6Si4t1NuDIlgn3aXVR2KCu9zcdGG7TYCbXIlr-ZMtmC5eeMCV30XwMikZpAP68scDEtAvabbc7vn6HHQtUgEQqKzsY8w1dpw	2021-08-25 02:34:14.163078+00	\N	Ninastaviski@gmail.com	8503462086	1629951287	AQDdchIGsqX_5SBeV1tTtkDscJfPNJ3iG1cLOZ4CXJic33aCMZAmZb5qJHTCaQHMdPQDB3tA7M3M8oJeuqfXlb_LOgilQowVKbEssTOOhRrnryipi9KOVHBAnI-4Cj2QgEs	5000
7	rea	BQCrzKlXUcd5grLSe9lvVqvtIcKjqBXpsjiu4DQ2tbNqi1wTyRA_sd_CyBhUDNQ3dvCx265d6Si4t1NuDIlgn3aXVR2KCu9zcdGG7TYCbXIlr-ZMtmC5eeMCV30XwMikZpAP68scDEtAvabbc7vn6HHQtUgEQqKzsY8w1dpw	2021-08-24 21:59:35.092488+00	\N	rethornberry@tamu.edu	4694223110	1629951287	AQDdchIGsqX_5SBeV1tTtkDscJfPNJ3iG1cLOZ4CXJic33aCMZAmZb5qJHTCaQHMdPQDB3tA7M3M8oJeuqfXlb_LOgilQowVKbEssTOOhRrnryipi9KOVHBAnI-4Cj2QgEs	5000
18	jedumo18		2021-08-26 13:34:44.684512+00	\N	jedumo18@gmail.com	\N			5000
19	boliverselle	BQCwPpCMK5zJgcooA-_8YLhKoHqzRef7gBB7JY9Yp081U1A2wDa6TV-sydgDWWc0v7tXUW_YeFqVr7qGw6e-7OEpvpWbHRslPnIVGdA3DCu6tsy-8bgj38zfMLS6w52i0kgWs6uvAtsweugUsysz08rAwzkEkXgb1lPeX99IK2Y	2021-08-26 14:03:31.284776+00	\N	boliverselle@gmail.com	4692365358	1629990412	AQC2x0USuqC3AUFCSSZC7_0GLpkbLbdspcuVlF6zP6Mnt6lh2kw30FFppFm4sX03jFsDnF2p8inoM__Ep5ikKv4e_s266_5xXSzY9JkiU7m1tZp-76a9_RiCcefU2qDyBPY	5000
14	deseree rios	BQCOUoV0ONFGSxBfqgdPQrmdSqo4BRNYNqm_JFoj1cmA5uNWZLcq_ufcjo9npy5_7TPrF3cV20_alKyCutis4nW2K8Ye0Sp4A_InjMBkCHAqPRoQcF0uM1X5QVlnnjXD_aMFp3y7FSMolRYMXAEsnba4H18umeFwx_k4WN2S0A	2021-08-25 19:30:45.821945+00	\N	Desereerios13@gmail.com	2103259466	1630028073	AQA62GK6Ra_Y8d7OHGQnzMOOb2-yXmFaML2_sNO3jNSWH0GLVnL_MvyB0gQfobvSIOuSTVlEn9QBuVM7t7fDIhKDGk4yv_110yjLG2xGqFFYx9fiaaZXpMcnubSAiuX2kLQ	5000
20	Justinrudi26	\N	2021-08-27 06:18:40.385443+00	\N	Justinrudi26@gmail.com	\N	\N	\N	5000
21	rebeccawilson1825	\N	2021-08-27 16:48:35.177735+00	\N	rebeccawilson1825@gmail.com	3122867881	\N	\N	5000
23	Grace Lorraine Sandstrum	\N	2021-08-28 03:54:31.043884+00	\N	gls2279@utexas.edu	8176929924	\N	\N	5000
24	Noahjws	\N	2021-08-28 18:44:14.487945+00	\N	Noahjws@gmail.com	\N	\N	\N	5000
25	tongchen105	\N	2021-08-29 22:30:06.359262+00	\N	tongchen105@gmail.com	\N	\N	\N	5000
22	ethan	BQC9mSdSwmKsATrEVUuVc2RxA8q0qvGSMEuKceiMtIgXEdo6fD03L6IjXnH5l4aYo83y6XJoCoEfM5rhIOVysq2s9aPkMZlloCcBQJPUNuiKWKhoRmXVq5IqNzg_irvRoD9WFLxaxK03khT8I4GLfqBQZtcRhgPZMPvspH88CWEOgzM2bUmb	2021-08-28 01:40:03.812016+00	\N	ethanshen1214@gmail.com	9728221233	1630116495	AQCk7FdF7Urvb_TUs8qwvdQHpr2umBYe_5s10lXtwS2DYHVkq9xw-nsa85A5HcTiu7qkcE-VaWTdMqCSSO5S4WuLF-liJiH9aFbBQ-ipAfNZA5LBFPhKtUsaSUQMUoXyc4Y	5000
28	Kendyll Gavras		2021-09-01 20:12:13.405851+00	\N	kendyllgavras@ou.edu	4057068815			5000
29	preston edison	BQAsArr_BAiWZuoExu5hg3haJ27UpfZUblLpCB64NhV4rDetr551-I6Lh9-nslZ3HKxO-QDdjkAt9y1irn1E45rpVdAlYTcOUblx17dG5eG8FVStkr0cqbe8X4Y0r1lmE3dAwXyslhWIvhejNO9zQ0CEirLwEdRFJ446p_je1hTQ	2021-09-01 23:15:15.127928+00	\N	prestonedison@icloud.com	8173438848	1630542314	AQCj4i_Y8FWmY0CZbch28YjOatLVuu7nZ8yDKjN-nI2v2PV_A1POdmROnVafmR-DviTU2VNphqZgH7tHuvCpNxB4TILGsmWDAD2cIvUJIPkOOOroICu7r5Eke_jyTE0ukgg	5000
30	J.jloi2200	\N	2021-09-02 00:57:49.023814+00	\N	J.jloi2200@gmail.com	\N	\N	\N	5000
32	higgihei	\N	2021-09-03 15:47:41.906093+00	\N	higgihei@utexas.edu	\N	\N	\N	5000
33	heidi higginson	BQB0wDI13OlAfmpSs8ETHVHuxSRtmyB0qkI8Hwlsek94kuIuV6z2c-u3ZcJMmrwfUtxUVjIE6NgN2goBKVeJvcX5LqVZU5IZ2bE3hmwu1Pevq9dsWynaL8TsZex4_KHRRSiwmBM-5z1cYAqPrkzvuaSsimMIAd9NyuBkAY0u0ZM1EBcVrVzGy2oDVRpJ	2021-09-03 15:49:48.85382+00	\N	higginsonheidiemail@gmail.com	7138545171	1630688420	AQAe6wmqbwPMxaYxfxnMfstUHhRNVcEJ8gTY1tlelm5obAZC0fFB1xRAT2yxQCroADZTsj1ja58sAlo6tif9VmF0JuefOn4UHYXi8uQ1C5k_-abp4aeYqsJ9tQvEckb32Mo	5000
34	Elise Gutierrez 	\N	2021-09-03 21:49:38.141367+00	\N	Gfamily4@outlook.com	2142054048	\N	\N	5000
1	thatcher	BQCtW9UwG0hqqL0YeHV6jqfoNjtK8lhWTLInu9m-G9xlt1LTq9YCJ5ef5Tc2TzVPn7-asZtMe5X6xI6qVKTqOZo2Q2_cXlC-0b0GIvwtQYJTsWyKPdwLmjl8kqi0Ii5-ulPz58hL2U_aPFao2noZnZ1GX41k5CSXIgCY1KUR64aLA8vZAya8	2021-08-24 16:50:52.931242+00	\N	thatcherthornberry@gmail.com	7372754382	1632890991	AQCk7FdF7Urvb_TUs8qwvdQHpr2umBYe_5s10lXtwS2DYHVkq9xw-nsa85A5HcTiu7qkcE-VaWTdMqCSSO5S4WuLF-liJiH9aFbBQ-ipAfNZA5LBFPhKtUsaSUQMUoXyc4Y	1610
4	hunter chemelli	BQCww7PIWfVBWqb_UgAGCRRcUekdeWtQJHvBRr1_Wc3a4Vznb8raIPNhDHF6XEDXYZuvB1UCKE7lqIV3W4fP9I8hQEbKNIwusksiQCadBmuxTcemCoz56ZqsgE75AxRHvcZaCggZ3TzRzqhbMqJeBEuFm2SOkdlq-8O2w0FZcQ	2021-08-24 17:10:31.218124+00	\N	hunterc1011@gmail.com	4692519679	1636781440	AQCIATwQ3c9CWboANT0WuwvG8ZEizQG0hwN9pDKVTnMpKN2SPEB5ch4bpi7W91C9Jr5elyP_szcAYcN1if_vTiGtT6lBkDb6dmNKgw01yF8XpUuzYY_kOpO0nrDKGBGUmwQ	2917
31	harry khuc	BQC7gGD-0Koy_q7UcLXpNq4Jlobv77HgyTznCykHXT4OAscsBwfvCuxWQ_HUMS5g_jiKiw9HIp8s9Osj6weJwD5krggIdmzkHwyq-9oY6QfIjt3YRbnuGlx9vTSsOrTuy4CGyiQBGwIBoYufNe0VTVnM26-gq3kRVxFlLZM	2021-09-02 21:56:49.278377+00	\N	harrykhuc@gmail.com	2816737223	1630833750	AQAaXWVeX9LAwF6zryQ62KP9ZO48pLQbZBoCTHAxuXwn85y2SjxqQyRRD3ruPJp_T79xgzvq-GMxkxgXd5IQkjSw3HhSb51svbsTc0EL_eRQPlg1EEdVDZwe4uIfQDqYBEA	5000
35	juanrtech	BQA4a7IbcmUB-7-jpdYSiI_2jrjZYnEIUxzKRQ5QtscnvlWBOg1ebRFByQ5iJz55KClJ-HJ5lkvASVuYLueZJ4p3jm1vwDLChEOaXP4pAE3dmwOK1-n1XIuI_NW6fWxNnC_z-GR3pe-OucxdZX_sMhJyLceFo5KAiMYwpkE	2021-09-06 19:09:19.408646+00	\N	juan@juanr.me	4088005826	1630982001	AQAaXWVeX9LAwF6zryQ62KP9ZO48pLQbZBoCTHAxuXwn85y2SjxqQyRRD3ruPJp_T79xgzvq-GMxkxgXd5IQkjSw3HhSb51svbsTc0EL_eRQPlg1EEdVDZwe4uIfQDqYBEA	5000
36	andrea mertins	BQBNIexVaYuc5N6E9NNVgVcvAXkwhc4Fv-LLXZ431d4IMSzv_iYBoqJcyqFE_zNkKWx3mg3q5l47XouNFHqc_zDSOhezJSRXcFLuI08pKuj_Y8_ilELh29iBLpe0ZjVVt8iENAcQgEGfpRbB_FcY2QjltfBtJ_eWKQfLKiOXqwrK8twr6gboq5OdctiT	2021-09-07 13:57:49.295934+00	\N	Andrea.mertins@utexas.edu	2816829499	1631039709	AQCUGga6_LQ_FEUeKoGt8VbQ16DEm2GBsyAknPFb_EtQkj5aUA9oQn0v-w7bvAsehX4rDs4jYOG1AUuh5EJOZPpeqyiLZe_KPiWZVdcawLdW04xjnoIuK5si3Q1u72HcHM4	5000
37	sbai1042	\N	2021-09-10 00:13:30.151383+00	\N	sbai1042@gmail.com	\N	\N	\N	5000
38	joshua	\N	2021-09-11 01:52:58.970856+00	\N	joshua@harpsoft.com	\N	\N	\N	5000
39	joewcozby		2021-09-13 04:00:13.027764+00	\N	joewcozby@comcast.net	8323509171			5000
40	victor	\N	2021-09-20 14:21:44.403393+00	\N	victor@sherhart.com	5127749454	\N	\N	5000
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 32, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 12, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 8, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 35, true);


--
-- Name: queueing_follower_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.queueing_follower_id_seq', 29, true);


--
-- Name: queueing_listener_id_seq; Type: SEQUENCE SET; Schema: public; Owner: thatcher
--

SELECT pg_catalog.setval('public.queueing_listener_id_seq', 40, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: queueing_follower queueing_follower_number_key; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_follower
    ADD CONSTRAINT queueing_follower_number_key UNIQUE (number);


--
-- Name: queueing_follower queueing_follower_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_follower
    ADD CONSTRAINT queueing_follower_pkey PRIMARY KEY (id);


--
-- Name: queueing_listener queueing_listener_name_key; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_listener
    ADD CONSTRAINT queueing_listener_name_key UNIQUE (name);


--
-- Name: queueing_listener queueing_listener_number_key; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_listener
    ADD CONSTRAINT queueing_listener_number_key UNIQUE (number);


--
-- Name: queueing_listener queueing_listener_pkey; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_listener
    ADD CONSTRAINT queueing_listener_pkey PRIMARY KEY (id);


--
-- Name: queueing_listener queueing_listener_spotify_id_key; Type: CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.queueing_listener
    ADD CONSTRAINT queueing_listener_spotify_id_key UNIQUE (spotify_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: queueing_listener_code_fb0b3b70_like; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX queueing_listener_code_fb0b3b70_like ON public.queueing_listener USING btree (token varchar_pattern_ops);


--
-- Name: queueing_listener_name_21a1839c_like; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX queueing_listener_name_21a1839c_like ON public.queueing_listener USING btree (name varchar_pattern_ops);


--
-- Name: queueing_listener_number_68092072_like; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX queueing_listener_number_68092072_like ON public.queueing_listener USING btree (number varchar_pattern_ops);


--
-- Name: queueing_listener_spotify_id_75c40dd2_like; Type: INDEX; Schema: public; Owner: thatcher
--

CREATE INDEX queueing_listener_spotify_id_75c40dd2_like ON public.queueing_listener USING btree (spotify_id varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: thatcher
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

