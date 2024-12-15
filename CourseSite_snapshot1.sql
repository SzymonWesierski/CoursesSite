--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6
-- Dumped by pg_dump version 16.6

-- Started on 2024-12-15 11:05:02

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

--
-- TOC entry 239 (class 1255 OID 16772)
-- Name: notify_messenger_messages(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_messenger_messages() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                PERFORM pg_notify('messenger_messages', NEW.queue_name::text);
                RETURN NEW;
            END;
        $$;


ALTER FUNCTION public.notify_messenger_messages() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 16655)
-- Name: cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart (
    id integer NOT NULL,
    user_id integer NOT NULL,
    amount_of_products integer,
    purchased boolean,
    purchased_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    total_value double precision NOT NULL
);


ALTER TABLE public.cart OWNER TO postgres;

--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN cart.purchased_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cart.purchased_at IS '(DC2Type:datetime_immutable)';


--
-- TOC entry 226 (class 1259 OID 16662)
-- Name: cart_course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_course (
    cart_id integer NOT NULL,
    course_id uuid NOT NULL
);


ALTER TABLE public.cart_course OWNER TO postgres;

--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN cart_course.course_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cart_course.course_id IS '(DC2Type:uuid)';


--
-- TOC entry 216 (class 1259 OID 16646)
-- Name: cart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_id_seq OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16669)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    parent_id integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16647)
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_id_seq OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16675)
-- Name: chapter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chapter (
    id integer NOT NULL,
    course_id uuid NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.chapter OWNER TO postgres;

--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN chapter.course_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chapter.course_id IS '(DC2Type:uuid)';


--
-- TOC entry 229 (class 1259 OID 16681)
-- Name: chapter_draft; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chapter_draft (
    id integer NOT NULL,
    course_draft_id uuid,
    name character varying(255) NOT NULL
);


ALTER TABLE public.chapter_draft OWNER TO postgres;

--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN chapter_draft.course_draft_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chapter_draft.course_draft_id IS '(DC2Type:uuid)';


--
-- TOC entry 219 (class 1259 OID 16649)
-- Name: chapter_draft_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chapter_draft_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chapter_draft_id_seq OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16648)
-- Name: chapter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chapter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chapter_id_seq OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16687)
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    id uuid NOT NULL,
    course_draft_id uuid NOT NULL,
    user_id integer NOT NULL,
    category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(1024) NOT NULL,
    image_path character varying(255) DEFAULT NULL::character varying,
    status character varying(64) NOT NULL,
    public_image_id character varying(255) DEFAULT NULL::character varying,
    price double precision,
    rating_average double precision NOT NULL
);


ALTER TABLE public.course OWNER TO postgres;

--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN course.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.course.id IS '(DC2Type:uuid)';


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN course.course_draft_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.course.course_draft_id IS '(DC2Type:uuid)';


--
-- TOC entry 231 (class 1259 OID 16699)
-- Name: course_draft; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_draft (
    id uuid NOT NULL,
    category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(1024) NOT NULL,
    image_path character varying(255) DEFAULT NULL::character varying,
    status character varying(64) NOT NULL,
    public_image_id character varying(255) DEFAULT NULL::character varying,
    price double precision
);


ALTER TABLE public.course_draft OWNER TO postgres;

--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN course_draft.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.course_draft.id IS '(DC2Type:uuid)';


--
-- TOC entry 215 (class 1259 OID 16640)
-- Name: doctrine_migration_versions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctrine_migration_versions (
    version character varying(191) NOT NULL,
    executed_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    execution_time integer
);


ALTER TABLE public.doctrine_migration_versions OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16709)
-- Name: episode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.episode (
    id integer NOT NULL,
    chapter_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    video_path character varying(255) DEFAULT NULL::character varying,
    image_path character varying(255) DEFAULT NULL::character varying,
    public_image_id character varying(255) DEFAULT NULL::character varying,
    public_video_id character varying(255) DEFAULT NULL::character varying,
    is_free_to_watch boolean NOT NULL
);


ALTER TABLE public.episode OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16722)
-- Name: episode_draft; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.episode_draft (
    id integer NOT NULL,
    chapter_draft_id integer,
    name character varying(255) NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    video_path character varying(255) DEFAULT NULL::character varying,
    image_path character varying(255) DEFAULT NULL::character varying,
    public_image_id character varying(255) DEFAULT NULL::character varying,
    public_video_id character varying(255) DEFAULT NULL::character varying,
    is_free_to_watch boolean NOT NULL
);


ALTER TABLE public.episode_draft OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16651)
-- Name: episode_draft_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.episode_draft_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.episode_draft_id_seq OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16650)
-- Name: episode_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.episode_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.episode_id_seq OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16760)
-- Name: messenger_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messenger_messages (
    id bigint NOT NULL,
    body text NOT NULL,
    headers text NOT NULL,
    queue_name character varying(190) NOT NULL,
    created_at timestamp(0) without time zone NOT NULL,
    available_at timestamp(0) without time zone NOT NULL,
    delivered_at timestamp(0) without time zone DEFAULT NULL::timestamp without time zone
);


ALTER TABLE public.messenger_messages OWNER TO postgres;

--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN messenger_messages.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.messenger_messages.created_at IS '(DC2Type:datetime_immutable)';


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN messenger_messages.available_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.messenger_messages.available_at IS '(DC2Type:datetime_immutable)';


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN messenger_messages.delivered_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.messenger_messages.delivered_at IS '(DC2Type:datetime_immutable)';


--
-- TOC entry 237 (class 1259 OID 16759)
-- Name: messenger_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messenger_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messenger_messages_id_seq OWNER TO postgres;

--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 237
-- Name: messenger_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messenger_messages_id_seq OWNED BY public.messenger_messages.id;


--
-- TOC entry 234 (class 1259 OID 16735)
-- Name: rating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rating (
    id integer NOT NULL,
    user_id integer NOT NULL,
    course_id uuid NOT NULL,
    value double precision NOT NULL,
    message character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.rating OWNER TO postgres;

--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN rating.course_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.rating.course_id IS '(DC2Type:uuid)';


--
-- TOC entry 222 (class 1259 OID 16652)
-- Name: rating_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rating_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rating_id_seq OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16743)
-- Name: reset_password_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reset_password_request (
    id integer NOT NULL,
    user_id integer NOT NULL,
    selector character varying(20) NOT NULL,
    hashed_token character varying(100) NOT NULL,
    requested_at timestamp(0) without time zone NOT NULL,
    expires_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.reset_password_request OWNER TO postgres;

--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN reset_password_request.requested_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.reset_password_request.requested_at IS '(DC2Type:datetime_immutable)';


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN reset_password_request.expires_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.reset_password_request.expires_at IS '(DC2Type:datetime_immutable)';


--
-- TOC entry 223 (class 1259 OID 16653)
-- Name: reset_password_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reset_password_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reset_password_request_id_seq OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16749)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(180) NOT NULL,
    roles json NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    is_verified boolean NOT NULL,
    public_image_id character varying(255) DEFAULT NULL::character varying,
    image_path character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16654)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4715 (class 2604 OID 16763)
-- Name: messenger_messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messenger_messages ALTER COLUMN id SET DEFAULT nextval('public.messenger_messages_id_seq'::regclass);


--
-- TOC entry 4933 (class 0 OID 16655)
-- Dependencies: 225
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, user_id, amount_of_products, purchased, purchased_at, total_value) FROM stdin;
85	85	0	f	\N	0
86	86	0	f	\N	0
87	87	0	f	\N	0
88	88	0	f	\N	0
89	89	0	f	\N	0
90	90	0	f	\N	0
91	91	0	f	\N	0
92	92	0	f	\N	0
93	93	0	f	\N	0
94	94	0	f	\N	0
95	95	0	f	\N	0
96	96	0	f	\N	0
97	97	0	f	\N	0
98	98	0	f	\N	0
99	99	0	f	\N	0
100	100	0	f	\N	0
101	101	0	f	\N	0
102	102	0	f	\N	0
103	103	0	f	\N	0
104	104	0	f	\N	0
105	105	0	f	\N	0
106	106	0	f	\N	0
107	107	0	f	\N	0
108	108	0	f	\N	0
109	109	0	f	\N	0
\.


--
-- TOC entry 4934 (class 0 OID 16662)
-- Dependencies: 226
-- Data for Name: cart_course; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_course (cart_id, course_id) FROM stdin;
\.


--
-- TOC entry 4935 (class 0 OID 16669)
-- Dependencies: 227
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, parent_id, name) FROM stdin;
261	\N	Development
262	261	Web Development
263	261	Mobile Development
264	261	Game Development
265	261	Data Science
266	\N	Business
267	266	Entrepreneurship
268	266	Management
269	266	Business Strategy
270	266	E-commerce
271	\N	Finance & Accounting
272	271	Personal Finance
273	271	Investing
274	271	Accounting Basics
275	271	Taxation
276	\N	IT & Software
277	276	Software Engineering
278	276	Cloud Computing
279	276	Cybersecurity
280	276	Networking
281	\N	Office Productivity
282	281	Microsoft Office
283	281	Google Workspace
284	281	Project Management
285	281	Time Management
286	\N	Personal Development
287	286	Self-Help
288	286	Motivation
289	286	Career Development
290	286	Public Speaking
291	\N	Design
292	291	Graphic Design
293	291	UX/UI Design
294	291	Web Design
295	291	3D Design
296	\N	Marketing
297	296	Digital Marketing
298	296	Content Marketing
299	296	Social Media Marketing
300	296	SEO
301	\N	Lifestyle
302	301	Travel
303	301	Cooking
304	301	Fashion
305	301	Personal Finance
306	\N	Photography & Video
307	306	Photography Basics
308	306	Video Editing
309	306	Lighting Techniques
310	306	Creative Photography
311	\N	Health & Fitness
312	311	Nutrition
313	311	Yoga
314	311	Fitness Training
315	311	Mental Health
316	\N	Music
317	316	Music Theory
318	316	Instrument Lessons
319	316	Music Production
320	316	Composition
321	\N	Teaching & Academics
322	321	Teaching Strategies
323	321	Educational Psychology
324	321	Curriculum Development
325	321	Online Teaching
\.


--
-- TOC entry 4936 (class 0 OID 16675)
-- Dependencies: 228
-- Data for Name: chapter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chapter (id, course_id, name) FROM stdin;
401	88e55600-7abc-46a7-82cb-dfea83f7d906	Chapter 1 of Course 1
402	9b4460c6-3125-4400-b7df-b2cd29a2dc5c	Chapter 1 of Course 2
403	88e764c2-5efb-4f49-b34b-5accf457393a	Chapter 1 of Course 3
404	9b4bcfc9-e9aa-453e-8fa8-364eb6173f94	Chapter 1 of Course 4
405	563cc32a-3eeb-47f9-8bc2-37935c9e02e3	Chapter 1 of Course 5
406	fb80b938-3cc4-40f3-8350-7f6ecc0f0f82	Chapter 1 of Course 6
407	101f4c40-bec2-40ed-977c-062e4ee54bb8	Chapter 1 of Course 7
408	c0ea97e9-e41c-4da7-84ba-fd6e8e25303d	Chapter 1 of Course 8
409	79c6560d-8e3e-4c38-beaf-8a9e099ddf70	Chapter 1 of Course 9
410	78749203-6740-48af-866c-9758b2c5f3ff	Chapter 1 of Course 10
411	8ea7186a-28de-4a5c-958d-da4062dc54d1	Chapter 1 of Course 11
412	010ca143-ba17-41b9-a2df-7ecdd26118d2	Chapter 1 of Course 12
413	98c172ba-9ac6-47d1-a98c-c731a62c99e9	Chapter 1 of Course 13
414	4ed9c751-d0a4-4dfc-855f-0159f5b44ba4	Chapter 1 of Course 14
415	5763e967-16f8-49e0-9765-6cfacd21fa42	Chapter 1 of Course 15
416	d27e5675-2705-43ca-9739-e8c269ca0964	Chapter 1 of Course 16
417	e41dff39-ae44-4881-b7fb-3d45bac4dede	Chapter 1 of Course 17
418	b9179693-8cb3-42ac-a3eb-a1d9bd32eabb	Chapter 1 of Course 18
419	d444fdf0-b035-46bc-9f01-48a232ea6014	Chapter 1 of Course 19
420	8cd7d339-0840-40b5-9eba-61198a806bec	Chapter 1 of Course 20
421	c3594e31-d8ea-4d6c-a992-3425bf33ae54	Chapter 1 of Course 21
422	7465b65f-4393-4e44-b84c-caa8666d92fd	Chapter 1 of Course 22
423	138d64e8-b660-4603-8250-71d04f4d374c	Chapter 1 of Course 23
424	415a629a-8919-49c4-a69f-a32667222dda	Chapter 1 of Course 24
425	a81103d1-af0b-4a2a-896f-83f0d66a994f	Chapter 1 of Course 25
426	27f59a2a-ab6e-4f88-9aab-a995fc2c7700	Chapter 1 of Course 26
427	6196d85c-3a4e-470c-9ded-5575406039a5	Chapter 1 of Course 27
428	9beb1e2f-b8e8-4ec7-9357-aea56de48c5f	Chapter 1 of Course 28
429	8e765044-d70d-467f-be8d-7c14d6ab7d88	Chapter 1 of Course 29
430	da2dd6cc-aa55-4f5d-9b3c-b6ea19a2e40c	Chapter 1 of Course 30
431	4003c42b-cc0a-404b-baa3-593ce7978540	Chapter 1 of Course 31
432	cb2105be-1020-47d2-a633-324b272da44b	Chapter 1 of Course 32
433	ea02cb59-bdb7-47be-ba67-b7e2ced46b94	Chapter 1 of Course 33
434	2177fe92-c93d-4001-bb5e-d32311de4c68	Chapter 1 of Course 34
435	58c30af1-af58-4d43-91c6-bb99e898801e	Chapter 1 of Course 35
436	1e7bdeba-d440-47a7-b000-de54ac4500d7	Chapter 1 of Course 36
437	236d3473-00fe-426c-b2a0-c85942cc0ac4	Chapter 1 of Course 37
438	cbf45cfc-9d2e-42dd-b1fb-2c67b6c0cd23	Chapter 1 of Course 38
439	df1391d8-6f71-4f6c-9fb8-3050f1093ddc	Chapter 1 of Course 39
440	21a4bba5-85f6-4273-a99c-e118fcea4e5a	Chapter 1 of Course 40
441	c97a62f6-542f-473f-b206-1a3a78285500	Chapter 1 of Course 41
442	488f047e-9c93-4abb-ad67-78a5ddbfeb1c	Chapter 1 of Course 42
443	a53c6cea-7453-4a6b-9236-da8e33b5c586	Chapter 1 of Course 43
444	16311b62-0a57-4430-9b27-86c62eb3670d	Chapter 1 of Course 44
445	098a18c2-1d38-4c4b-9cb7-09223e3f8f56	Chapter 1 of Course 45
446	0a194dec-d1da-45a8-98e0-5889d44bbf37	Chapter 1 of Course 46
447	b3ee653e-91d2-4351-a21f-2428ff78a784	Chapter 1 of Course 47
448	a0ecfe54-867d-4a4e-b9e1-239db095307f	Chapter 1 of Course 48
449	75b02db1-9c75-45b0-9afe-5595502f9402	Chapter 1 of Course 49
450	e2b7c840-9ddd-43f6-a20c-7dedbfc4f2b8	Chapter 1 of Course 50
451	9948c34e-6784-4616-aaef-573ca842f3cc	Chapter 1 of Course 51
452	c87126a9-6906-4831-be96-d8581de45e23	Chapter 1 of Course 52
453	ff86a6c0-1ab8-4d99-b93d-cee1ba1daa9d	Chapter 1 of Course 53
454	25291e8d-6051-47b6-9836-0ea5ec6dd227	Chapter 1 of Course 54
455	06de03ef-b26e-414a-9fd6-a3755b688040	Chapter 1 of Course 55
456	8c05c8fa-6112-4e0b-98f1-10133da37dd2	Chapter 1 of Course 56
457	ae7eeb1a-2aa0-4d61-8a2d-de4fa75e37bc	Chapter 1 of Course 57
458	42d1389d-220f-49c0-b54f-93f2b6e9fe93	Chapter 1 of Course 58
459	d186a20d-669d-4cab-a160-c5101b7634ce	Chapter 1 of Course 59
460	12693722-7648-44fd-97d5-bd53f5f10915	Chapter 1 of Course 60
461	86051fcb-c598-4d30-9876-f1b0ff0e01d7	Chapter 1 of Course 61
462	f68deca5-13ec-4365-afcc-c2211c0087e5	Chapter 1 of Course 62
463	6103ed90-5ed7-41d4-95d3-1a828a634dee	Chapter 1 of Course 63
464	b99c82e8-e255-4022-a2a8-5da96945dbd5	Chapter 1 of Course 64
465	a3924cbc-2e50-419c-99ec-b6d2f1ea4972	Chapter 1 of Course 65
466	bc7e166e-ca50-42fb-b74d-f873fd910584	Chapter 1 of Course 66
467	930051ba-593b-4149-b803-91692f741642	Chapter 1 of Course 67
468	abf90775-1815-4c94-a9d0-1c67c175bc9b	Chapter 1 of Course 68
469	f6e96946-0f42-4dc6-b0f4-c209898c4917	Chapter 1 of Course 69
470	9fff4c10-bed3-4c50-b9ee-88f8aa62430e	Chapter 1 of Course 70
471	33baab00-b052-43f2-b1e2-271ea16f9970	Chapter 1 of Course 71
472	3ce309ee-6109-4946-8872-89fe0d0140e3	Chapter 1 of Course 72
473	49f30d13-f21e-4ac4-99ca-34f79df18122	Chapter 1 of Course 73
474	587e82e0-0760-42f8-b9cd-ce35ef7ceaa9	Chapter 1 of Course 74
475	4b3189bd-8fce-4fa8-8c68-06c370f15b92	Chapter 1 of Course 75
476	742b4e07-382e-430b-a02e-76495e416ae5	Chapter 1 of Course 76
477	3eedf253-b6c9-405d-b971-66c90cd18547	Chapter 1 of Course 77
478	142ae327-f5f1-4d4c-8823-899a7f78a102	Chapter 1 of Course 78
479	d2a1da64-937c-46ea-9e50-ad9f24fc8cec	Chapter 1 of Course 79
480	24c95b55-0d54-473f-8581-2dff794c72c4	Chapter 1 of Course 80
481	1c5a3a35-4581-4bb4-9b39-a1fd2cf97b19	Chapter 1 of Course 81
482	a5563359-a1b0-46a1-aaa3-8f234549fad5	Chapter 1 of Course 82
483	df56da09-dbbc-480b-a16f-a7d8e386ee57	Chapter 1 of Course 83
484	914e994e-7c0f-45fd-83eb-5c4968a75c98	Chapter 1 of Course 84
485	89d755e3-6414-426b-a754-ae36960f2cca	Chapter 1 of Course 85
486	ec2ab57f-202a-4029-8ab1-0cc72ad611ee	Chapter 1 of Course 86
487	0bdf5acf-332d-4560-99c7-39469a1f293d	Chapter 1 of Course 87
488	1f47f2c9-7192-4a02-9040-9f13f1183d48	Chapter 1 of Course 88
489	b107f8b9-1fa5-43a0-8c4c-0578e255cae0	Chapter 1 of Course 89
490	84253cd3-c720-448f-8488-ecb68ee2b9de	Chapter 1 of Course 90
491	bda7e996-09bd-48cf-9f43-05c44527164d	Chapter 1 of Course 91
492	013fbdc2-6959-466d-ba2a-484cde6b7a56	Chapter 1 of Course 92
493	480b687a-d17c-4ff7-964c-7bc1b5222918	Chapter 1 of Course 93
494	255de658-c216-48b4-9bfd-f4d4f078cda9	Chapter 1 of Course 94
495	991619ba-0002-4582-9813-1c73ecba3228	Chapter 1 of Course 95
496	f6b05cbc-0430-4654-a3ea-646f9fefdcae	Chapter 1 of Course 96
497	f6452b49-a4ca-4d0c-a1a7-e0884fa2e118	Chapter 1 of Course 97
498	d2cb899c-580c-4334-9bf4-7e7f802ad613	Chapter 1 of Course 98
499	34752141-dac3-436f-9b2a-20ad263681da	Chapter 1 of Course 99
500	159aa83f-7b6f-4c00-8b2d-89926c89ab5f	Chapter 1 of Course 100
\.


--
-- TOC entry 4937 (class 0 OID 16681)
-- Dependencies: 229
-- Data for Name: chapter_draft; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chapter_draft (id, course_draft_id, name) FROM stdin;
401	ab7fda69-cc50-4f88-893f-d0d6856cd41f	Chapter 1 of Course 1
402	58f1d5db-23ea-40ca-847e-420cb60073ca	Chapter 1 of Course 2
403	06bc9988-d285-40fa-94eb-87ef36d54e8c	Chapter 1 of Course 3
404	ac622ebd-9a5a-4232-a91f-c8e4294b2b77	Chapter 1 of Course 4
405	cce759cc-f400-46d9-9576-db7719aec877	Chapter 1 of Course 5
406	5132c01c-b5ed-4660-a743-8998ca3009e6	Chapter 1 of Course 6
407	6e90f087-4ba8-4c21-bea5-7d02851e6af2	Chapter 1 of Course 7
408	57ffbb64-70c6-4ad6-9f06-eafea2349fab	Chapter 1 of Course 8
409	fd3913db-13f3-46d4-bf7e-5853d2f173da	Chapter 1 of Course 9
410	6bf1c2e3-0544-4edc-9a6f-5998d619a3fc	Chapter 1 of Course 10
411	3a266a53-739e-44d8-ad15-2804e09e4107	Chapter 1 of Course 11
412	fafb327b-6f56-45d6-9ea4-43ce6dcb4e5c	Chapter 1 of Course 12
413	da5dbf21-65b4-4860-9402-4cd927cca99d	Chapter 1 of Course 13
414	3f5645ea-2b83-47c6-a8b1-f5d0b31c94e0	Chapter 1 of Course 14
415	4b02dc17-b042-4c39-aa6e-4526693adf25	Chapter 1 of Course 15
416	00d7509a-4449-403e-b840-65ba577e6451	Chapter 1 of Course 16
417	b40667ba-2bde-4c3c-8150-588c9f90e826	Chapter 1 of Course 17
418	27479711-c932-415f-bfa7-3a2e7d01535d	Chapter 1 of Course 18
419	436f3ccf-3a28-4473-b4ea-a18ac740144e	Chapter 1 of Course 19
420	c21aa487-4469-4cf8-aa88-d7b250380603	Chapter 1 of Course 20
421	5ab8314a-e8c8-4d64-9c16-9c7f4ed58b0f	Chapter 1 of Course 21
422	fe4e594d-c634-4cb1-81e3-5fa7bafd421a	Chapter 1 of Course 22
423	cd082611-9376-4fb3-9585-3e89f5fce16c	Chapter 1 of Course 23
424	527c93c2-ff56-4c0f-9a38-2198aa697d49	Chapter 1 of Course 24
425	5966bf52-d026-4fb4-8d6a-0b99c02d8144	Chapter 1 of Course 25
426	7a26f752-850e-4def-b08f-8e391d5a51c4	Chapter 1 of Course 26
427	756599b6-343e-43d8-880b-ca9fa56efc94	Chapter 1 of Course 27
428	7af90bc1-a89c-42ea-9d25-61312b0bfc80	Chapter 1 of Course 28
429	1b527bae-1776-4e97-811a-e6ee0ac9b856	Chapter 1 of Course 29
430	b462562b-2f98-4f26-bec1-1b8eb04bd14e	Chapter 1 of Course 30
431	2002c367-7681-4ff6-9d7a-aeb9f372848d	Chapter 1 of Course 31
432	08344e18-07fd-48b1-9ed0-859cea43b0c1	Chapter 1 of Course 32
433	0f26c98c-376d-49de-9633-7fe4899f67f8	Chapter 1 of Course 33
434	8f41dec1-420c-44f5-ab60-f5e35d921efb	Chapter 1 of Course 34
435	c1bd639a-ebd9-4af1-82b8-b28797a22aac	Chapter 1 of Course 35
436	ee917493-50c9-4f94-bd87-f416bf21593d	Chapter 1 of Course 36
437	073756d8-3eff-4831-a1ae-4323f1d2aea8	Chapter 1 of Course 37
438	ee972a66-db08-4fe5-bf26-b607701a9d7a	Chapter 1 of Course 38
439	d15c3de1-b9e4-4e27-84c1-60a540dcbe40	Chapter 1 of Course 39
440	4de728ef-3d78-4551-a568-2066c8285c96	Chapter 1 of Course 40
441	bd8fbf79-2de0-40cc-8aa1-d75a75163919	Chapter 1 of Course 41
442	e17d877e-f91b-4d36-84cf-32a64ec7c629	Chapter 1 of Course 42
443	12d5a16e-acf3-406c-ae67-94548005162b	Chapter 1 of Course 43
444	882dbe79-7285-42e6-bd84-ec4826060010	Chapter 1 of Course 44
445	429218cb-6972-43f2-add7-8029d17119ab	Chapter 1 of Course 45
446	c28f47fb-efdf-41f4-9625-04755f3aceab	Chapter 1 of Course 46
447	c3e158df-9779-4e7e-9ac5-6b2c607b741b	Chapter 1 of Course 47
448	7b633950-129b-4cb7-8a31-0f52114793ab	Chapter 1 of Course 48
449	f3d647d4-1002-4358-9a7a-fcf1c3691b39	Chapter 1 of Course 49
450	3387ba2b-24e8-47e5-bd7e-cbe61c6136ad	Chapter 1 of Course 50
451	77e75adb-20e4-495c-beeb-98f275b8224b	Chapter 1 of Course 51
452	285bafd9-3fd1-4812-bd1e-1eb54abd8d15	Chapter 1 of Course 52
453	0ac35814-5b07-4219-aa80-89c7c6fd3cc8	Chapter 1 of Course 53
454	1f99e13f-acd6-4f7a-93ce-8fcad70bca45	Chapter 1 of Course 54
455	3e2ccf51-53e2-4d47-9749-278b0c906d25	Chapter 1 of Course 55
456	3e2171bb-4900-44dc-95a6-b90778f25513	Chapter 1 of Course 56
457	180b0506-c433-4118-a5d5-b8f1d67e12c5	Chapter 1 of Course 57
458	2ee89b82-742d-401e-b50d-0f56d836ebd1	Chapter 1 of Course 58
459	7c81dcdb-d6cb-4178-81cb-786c910a4b28	Chapter 1 of Course 59
460	2bcd374c-0933-4f1e-a0f7-1cdc369cf820	Chapter 1 of Course 60
461	cc1fc1a2-b893-4cb3-a2d2-5872903a06eb	Chapter 1 of Course 61
462	2a60da79-bdd8-48cd-8368-d6cb8726ca33	Chapter 1 of Course 62
463	6268f659-b7a7-4d6f-a9c1-7a539bbf2666	Chapter 1 of Course 63
464	83af701f-37b5-419d-b9a7-ab0b6a303881	Chapter 1 of Course 64
465	cfb9b5d7-679b-4ffc-bdd7-c0a5ba87d0e0	Chapter 1 of Course 65
466	9bc67eda-a78a-46f7-9dc4-f32933a7df80	Chapter 1 of Course 66
467	3b6fe60a-4659-48b8-bbb1-ed3bd62f148f	Chapter 1 of Course 67
468	0c197781-d730-478e-9fc6-c2905a1912c8	Chapter 1 of Course 68
469	9e03071f-7301-4f4a-80c8-797630dd28e8	Chapter 1 of Course 69
470	53f0a77b-a476-4b20-b462-7b8d6c3d8ae6	Chapter 1 of Course 70
471	04980870-e5b6-49e5-8b37-480beb6ff656	Chapter 1 of Course 71
472	f531ef61-3e84-4abb-8141-f98bf006d189	Chapter 1 of Course 72
473	57c654cb-b1ae-429d-bacc-c38c565d219d	Chapter 1 of Course 73
474	9d090d0b-14c3-4b03-b4cf-094c1f5189f0	Chapter 1 of Course 74
475	915779e6-d6d4-4c90-89da-9f558a9d847f	Chapter 1 of Course 75
476	713a15cc-20e5-4f0f-874a-a8d27b356ba7	Chapter 1 of Course 76
477	b8874757-3a3d-4e72-a53f-180fc523b538	Chapter 1 of Course 77
478	fbf834ef-ea76-4aed-986e-bd199f342a21	Chapter 1 of Course 78
479	2ba099a5-26a2-4426-a820-5b38803e8a95	Chapter 1 of Course 79
480	8efd743d-fcaa-468c-b3d6-693fc90218df	Chapter 1 of Course 80
481	76c52bbf-3785-401e-8769-4a375242e8f1	Chapter 1 of Course 81
482	0d18a042-53a6-4b8a-af6b-f2fbc317db2c	Chapter 1 of Course 82
483	0018f28d-245a-4c69-89de-280927f40cdb	Chapter 1 of Course 83
484	5d3437ca-1563-41da-8eea-c5780e6c355c	Chapter 1 of Course 84
485	aaac4952-a5f7-4ce7-b3b9-68c23c7f7fd2	Chapter 1 of Course 85
486	d56e0cae-5aa1-4eee-a86e-db0ebbe57e31	Chapter 1 of Course 86
487	feec659e-b1c7-4fcc-b361-8f2b73b08e96	Chapter 1 of Course 87
488	ce905ec9-52fa-44e3-ae76-2b54c31750cd	Chapter 1 of Course 88
489	ef87ad36-e9a7-4760-9e72-b79d8518d561	Chapter 1 of Course 89
490	8773681b-a255-4227-98bb-0cf5c19cbfb6	Chapter 1 of Course 90
491	4e8ceb76-fe35-44f2-a82f-e205aec183c7	Chapter 1 of Course 91
492	249a333a-041a-464c-a858-d796e0fc7716	Chapter 1 of Course 92
493	199b5d5e-1639-4302-8ee2-869f6589ef83	Chapter 1 of Course 93
494	0df8a323-01fc-4f5a-b92c-ceaf6119003e	Chapter 1 of Course 94
495	dedcdcd9-6dd3-4d54-88bb-1db22991e19c	Chapter 1 of Course 95
496	814f4998-09a1-4752-9095-df4c1a3718a6	Chapter 1 of Course 96
497	73f45241-2f28-4b1c-879c-46ecc6ec9055	Chapter 1 of Course 97
498	138fd8e5-81b6-4fa1-888d-0e792fbc2827	Chapter 1 of Course 98
499	8bfbcabd-027d-476c-a38d-7400a924663f	Chapter 1 of Course 99
500	b5f9811e-96e4-4af6-9189-89413afbebc6	Chapter 1 of Course 100
\.


--
-- TOC entry 4938 (class 0 OID 16687)
-- Dependencies: 230
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course (id, course_draft_id, user_id, category_id, name, description, image_path, status, public_image_id, price, rating_average) FROM stdin;
88e55600-7abc-46a7-82cb-dfea83f7d906	ab7fda69-cc50-4f88-893f-d0d6856cd41f	85	263	Course 1	Non dolor et repellendus quo vel officia assumenda. Amet ullam ducimus beatae totam. Repellendus dolore eos ullam modi placeat. Quas adipisci aut omnis quibusdam. Rerum facilis voluptatum expedita qui omnis. Dolorem nihil dolorem ducimus fugiat eaque est. Corporis qui at recusandae ab. Amet ea natus sapiente ex. Perspiciatis recusandae aspernatur aut atque expedita rerum in sunt. Autem non fuga recusandae sed dolores est quia.	/images/course_example_image.png	approved	\N	72.24	4.75
9b4460c6-3125-4400-b7df-b2cd29a2dc5c	58f1d5db-23ea-40ca-847e-420cb60073ca	85	287	Course 2	Tempore iure error doloribus sit sint. Sed et dignissimos ut minus. Ut quaerat doloremque et sit molestias eos dolorem. Autem distinctio et reiciendis. Deserunt ab ab sunt necessitatibus. Voluptatem est sunt qui. Consectetur voluptatem perspiciatis doloribus. Ab veniam aut possimus maiores quam necessitatibus a. Quae totam quod libero suscipit dolorem odit blanditiis amet. Consectetur quos et cupiditate animi possimus.	/images/course_example_image.png	approved	\N	54.07	3.65
88e764c2-5efb-4f49-b34b-5accf457393a	06bc9988-d285-40fa-94eb-87ef36d54e8c	85	309	Course 3	Et eligendi ut quo quas. Ipsum quaerat nobis rerum ducimus ut unde. Vel et quis vel in. A occaecati eum assumenda. Rem iure est reiciendis quia voluptatem architecto velit repellendus. Cupiditate ratione quam officiis exercitationem autem at. Labore at exercitationem dolorum. Est illum non quibusdam sint rem. Nobis qui sit consequatur reiciendis. Voluptatibus distinctio eum et laboriosam.	/images/course_example_image.png	approved	\N	88.69	4.77
9b4bcfc9-e9aa-453e-8fa8-364eb6173f94	ac622ebd-9a5a-4232-a91f-c8e4294b2b77	85	293	Course 4	Corrupti natus ea quidem quia eveniet corrupti necessitatibus quos. Voluptatem quia ea ut ab omnis praesentium. Beatae corrupti expedita aut minima dolorum. Laudantium magni sit blanditiis numquam. Quia quas neque nesciunt dolore quo qui voluptate incidunt. Provident cupiditate fuga temporibus sit temporibus. Et illo dolorem in ex. Cupiditate omnis nesciunt est iure eius dolores ut. Inventore est atque est dolor ut. Deleniti omnis velit et vel.	/images/course_example_image.png	approved	\N	56.9	4.3
563cc32a-3eeb-47f9-8bc2-37935c9e02e3	cce759cc-f400-46d9-9576-db7719aec877	85	300	Course 5	Est facere optio aspernatur consequuntur et dolor sapiente. Sint dolore nisi eaque officia voluptatem velit voluptas. Architecto maiores fugit est qui. Quia ut deserunt provident nesciunt corrupti unde. Sit expedita doloremque nulla sequi. Quia ipsum quidem quaerat repellat eos molestiae. Totam hic quidem qui quasi itaque voluptatem. Ducimus a alias quia aut pariatur inventore eum. Aperiam aut eum et a tenetur et qui. Aspernatur praesentium perferendis modi quaerat illum nesciunt ut eos.	/images/course_example_image.png	approved	\N	61.34	4.41
fb80b938-3cc4-40f3-8350-7f6ecc0f0f82	5132c01c-b5ed-4660-a743-8998ca3009e6	85	268	Course 6	Quis ducimus voluptatem omnis. Et molestias quam recusandae debitis nihil. Magni minus alias aut aperiam odio iste eum. Corporis ut dolorem sint est libero autem illo. Iste est mollitia aut quia dolores. Rerum tempore error ducimus magnam. Omnis ipsa tempore labore accusamus. Molestiae non nesciunt minus aut voluptatum explicabo voluptate. Ex facilis aut consequatur. Et iste suscipit consequatur ut perspiciatis enim dolor.	/images/course_example_image.png	approved	\N	97.65	4.61
101f4c40-bec2-40ed-977c-062e4ee54bb8	6e90f087-4ba8-4c21-bea5-7d02851e6af2	85	325	Course 7	Reiciendis repellat porro omnis voluptatem molestiae vitae accusantium. Nesciunt consequuntur ad molestiae quibusdam quae. Sed in minima enim provident esse necessitatibus. Aut perferendis magnam ratione doloremque labore. Dolorem animi sed est ab id. Tempora ut sit debitis quia illum. Nam et similique reiciendis fugit non voluptas. Quia ad recusandae est recusandae consequatur asperiores. Deleniti doloremque nulla voluptatum cumque in blanditiis dolores explicabo. Qui tenetur minus quaerat repellat saepe sit.	/images/course_example_image.png	approved	\N	71.65	3.19
c0ea97e9-e41c-4da7-84ba-fd6e8e25303d	57ffbb64-70c6-4ad6-9f06-eafea2349fab	85	313	Course 8	Vel dolorem non debitis perferendis eos modi ratione et. Quia odit fugiat nisi reprehenderit. Provident voluptatum sint quisquam perferendis qui dolorem voluptatem. Atque saepe dolorum quisquam nulla maxime eos. Tempore at ea deleniti occaecati non molestiae. Numquam eum quidem sit maiores tempore quia accusamus. Aliquid est aut ut harum excepturi. Iste qui blanditiis id aut quibusdam sint atque maxime. Et corporis laborum voluptatem quae. Sint consequuntur animi rerum debitis quasi molestias quisquam.	/images/course_example_image.png	approved	\N	52.01	3.56
79c6560d-8e3e-4c38-beaf-8a9e099ddf70	fd3913db-13f3-46d4-bf7e-5853d2f173da	85	322	Course 9	Maxime laboriosam distinctio velit omnis exercitationem nostrum. Dolorem rem voluptas quam laborum deleniti voluptatem. Eum alias veniam quidem quas. Et quis vel non quis vel. Aut voluptas est molestias inventore earum earum placeat nesciunt. Illum doloremque optio non maiores qui. Repudiandae suscipit molestiae eum aliquid quisquam rem perferendis enim. At est quos nihil sint. Distinctio blanditiis amet corporis minima laborum. Magnam quos quia ea ducimus dolores.	/images/course_example_image.png	approved	\N	95.44	3.52
78749203-6740-48af-866c-9758b2c5f3ff	6bf1c2e3-0544-4edc-9a6f-5998d619a3fc	85	287	Course 10	Praesentium earum et praesentium. Tempore libero deserunt nesciunt voluptas. Fugit doloremque alias aperiam quibusdam. Nihil veritatis commodi et labore non consequatur amet. Ab maxime voluptas non corrupti. Qui qui vero autem voluptatem. Aut labore minima quis vel quia ut. Inventore qui aut hic id voluptates ipsa. Consequuntur exercitationem excepturi qui distinctio. Consequatur est nostrum alias porro dolorum iusto.	/images/course_example_image.png	approved	\N	73.04	3.95
8ea7186a-28de-4a5c-958d-da4062dc54d1	3a266a53-739e-44d8-ad15-2804e09e4107	85	265	Course 11	Omnis quia rerum est ipsam est. Earum et vero sequi sed accusantium iste facilis. Labore eum vel quos rem blanditiis excepturi saepe. Quos dolores quo commodi omnis laboriosam doloribus. Nihil adipisci iste at error. Harum praesentium odit ad sint sapiente consequatur. Quisquam laudantium animi aperiam. Voluptate quo saepe repudiandae quo et illo. Voluptatem rerum dolore id et omnis. Asperiores exercitationem molestiae et voluptatibus excepturi vero molestiae.	/images/course_example_image.png	approved	\N	54.92	4.24
010ca143-ba17-41b9-a2df-7ecdd26118d2	fafb327b-6f56-45d6-9ea4-43ce6dcb4e5c	85	277	Course 12	Est natus excepturi temporibus fuga ut vel. Et modi qui commodi magnam. Perferendis fugiat voluptas qui voluptatibus similique aliquid aut. Laboriosam consectetur laborum dolorum expedita et. Dolorum quis earum nam veniam non quibusdam vero. Consequuntur voluptate veritatis id reprehenderit hic aut. Quia perspiciatis deserunt voluptas in. Laudantium ad fugit aut quae minus. Voluptate alias repellat magnam dolorum corrupti quos laudantium. Alias qui qui ea laborum accusamus magnam nulla dolores.	/images/course_example_image.png	approved	\N	95.41	3.15
98c172ba-9ac6-47d1-a98c-c731a62c99e9	da5dbf21-65b4-4860-9402-4cd927cca99d	85	325	Course 13	Sit non et vero iure at nostrum. Alias nam nihil cupiditate deleniti ipsum velit et. Deleniti ut voluptas quasi. Et quod voluptas maxime voluptatibus. Aperiam dignissimos officia quo est. Ipsum doloremque ipsa voluptatem qui omnis ut ut. Enim id sed corrupti fugit pariatur. Omnis quam veniam tenetur delectus necessitatibus sunt accusamus quia. Animi possimus iusto culpa asperiores. Velit enim est accusamus doloremque et.	/images/course_example_image.png	approved	\N	97.78	4.96
4ed9c751-d0a4-4dfc-855f-0159f5b44ba4	3f5645ea-2b83-47c6-a8b1-f5d0b31c94e0	85	282	Course 14	Accusantium at voluptatem odio laudantium. Autem sed vel sequi at molestiae. Dolor quo quas ex qui delectus aut. Cum voluptatibus quo repellendus. Qui odio sint aut enim ipsa. Eveniet dolore vel velit. Distinctio autem et animi beatae odio voluptas. Error facere est quis ut. Et dolorem magnam ex magnam voluptatem delectus quis. Doloremque nihil exercitationem dicta numquam.	/images/course_example_image.png	approved	\N	67.43	4.29
5763e967-16f8-49e0-9765-6cfacd21fa42	4b02dc17-b042-4c39-aa6e-4526693adf25	85	309	Course 15	Aperiam laudantium voluptates est enim ut. Assumenda maxime iure amet. Sit quia ad repudiandae. Aut sapiente iure unde eveniet dolores et. Nostrum quod iste ea enim sequi. Et at non provident qui. Dolor id consequatur rerum consequatur unde. Nihil debitis quibusdam debitis nobis commodi est. Sed aut doloribus et sed. Ex perspiciatis est aut.	/images/course_example_image.png	approved	\N	90.07	4.5
d27e5675-2705-43ca-9739-e8c269ca0964	00d7509a-4449-403e-b840-65ba577e6451	85	298	Course 16	Adipisci quibusdam accusamus ducimus qui dolorum. Illo voluptatem expedita sed praesentium autem animi. Nostrum ipsum possimus dolore perspiciatis. Recusandae voluptatem asperiores quia a labore. Dolor ea quia sint. Tempora autem aut omnis qui deserunt qui. Debitis quia voluptatem corporis nemo laboriosam animi rem. Cupiditate repellendus doloribus officia repellat sunt quidem occaecati suscipit. Numquam enim eligendi aut minima a ratione. Officiis ut et deserunt ipsam.	/images/course_example_image.png	approved	\N	87.33	3.69
e41dff39-ae44-4881-b7fb-3d45bac4dede	b40667ba-2bde-4c3c-8150-588c9f90e826	85	289	Course 17	Aliquam ab consequatur totam asperiores sint nemo consequatur architecto. Est aut laboriosam qui. Fugit dignissimos tempora enim consectetur veritatis id. Harum odio commodi deserunt voluptatum. Nemo reiciendis molestiae est. Hic blanditiis eveniet sint quo. Velit quis voluptas maiores rem culpa est et. Labore dolores labore deleniti est ipsum quia tempora. Consequuntur commodi rerum suscipit cupiditate soluta aspernatur necessitatibus. Sapiente nesciunt et qui quasi voluptatem et quo.	/images/course_example_image.png	approved	\N	60.8	4.31
b9179693-8cb3-42ac-a3eb-a1d9bd32eabb	27479711-c932-415f-bfa7-3a2e7d01535d	85	308	Course 18	Aperiam nam dolor assumenda sit architecto explicabo aliquid. Cum id aut consectetur adipisci. Omnis in ipsam ut iure maxime corrupti. Sequi quaerat non et dolorem qui sed sit. Sunt aliquid voluptas architecto labore. Ratione pariatur culpa dolore aut sunt voluptas ipsam dolorem. Necessitatibus cum eum velit non ut provident laborum a. Autem ipsa quibusdam ut est. Modi et autem a non accusantium esse. Sit vero magni voluptatem facere nam error.	/images/course_example_image.png	approved	\N	51.6	3.59
d444fdf0-b035-46bc-9f01-48a232ea6014	436f3ccf-3a28-4473-b4ea-a18ac740144e	85	298	Course 19	Quam suscipit sed distinctio nobis commodi unde voluptate alias. Labore voluptatem nisi officiis quos eligendi. Vel earum ut provident hic. Omnis et maiores quasi autem. Et neque quidem alias eius modi. Inventore doloribus maiores velit et. Necessitatibus ut eligendi autem facilis magnam. Doloribus occaecati placeat et vitae. Est est repellat qui repellat reprehenderit ea. Reiciendis dolor impedit a tempora non dicta dolorem.	/images/course_example_image.png	approved	\N	67.48	3.83
8cd7d339-0840-40b5-9eba-61198a806bec	c21aa487-4469-4cf8-aa88-d7b250380603	85	320	Course 20	Magni ex ducimus harum enim similique perspiciatis. Excepturi voluptatem consectetur et nihil voluptatem. Ex officiis enim qui beatae. Minus aliquam quae dolor dicta eum recusandae beatae. Consequuntur debitis ea commodi accusantium. Quos vel neque consequatur enim tempora. Aliquam qui maxime quidem odit. Tempora et omnis dolorem aut sunt. Et omnis ullam aut est. Quidem ducimus soluta aut iste.	/images/course_example_image.png	approved	\N	68.94	4.65
c3594e31-d8ea-4d6c-a992-3425bf33ae54	5ab8314a-e8c8-4d64-9c16-9c7f4ed58b0f	85	283	Course 21	Voluptate officia iusto voluptas architecto nostrum rem. Et et molestiae ex et non et culpa. Natus ut saepe sed deserunt dolorem placeat. Debitis culpa quia sit velit. Voluptas dolorem consequatur adipisci numquam. Ratione at ut est ex nulla excepturi omnis. Nisi sed similique ut commodi et. Vel non quia incidunt sit ullam labore. Molestias totam unde culpa odio non labore reiciendis. Aspernatur alias atque possimus fugiat.	/images/course_example_image.png	approved	\N	71.96	3.89
7465b65f-4393-4e44-b84c-caa8666d92fd	fe4e594d-c634-4cb1-81e3-5fa7bafd421a	85	279	Course 22	Ex architecto molestiae at cupiditate aut voluptatem. Laboriosam sed laboriosam provident ex tempore ut eveniet. Est accusantium amet sit. Asperiores et ullam pariatur sapiente error temporibus. Facilis aspernatur est qui error a voluptates. Eos exercitationem cupiditate odio consequuntur tempore ipsa ad. Architecto sit similique earum pariatur cupiditate ex quos. Dolorum corporis accusamus corrupti quibusdam. Cupiditate nesciunt pariatur repellat accusamus illo magni. Numquam possimus molestiae qui ut odio libero modi.	/images/course_example_image.png	approved	\N	54.16	4.58
138d64e8-b660-4603-8250-71d04f4d374c	cd082611-9376-4fb3-9585-3e89f5fce16c	85	289	Course 23	Eius ipsam quis libero ex quis quibusdam rerum. Soluta facilis quidem repudiandae quas est ea et sunt. A perspiciatis pariatur harum in omnis cum deleniti. Laudantium ratione et et dolorem. Rerum molestiae fugiat non. Sint aut et corrupti enim est voluptatem consequatur. Fuga possimus tempore doloribus esse assumenda quis praesentium quasi. Maiores consequatur vero autem cumque sequi illo voluptatem. Enim sit alias fuga voluptates odio aut dolores qui. Unde deserunt dolor debitis.	/images/course_example_image.png	approved	\N	55.76	3.58
415a629a-8919-49c4-a69f-a32667222dda	527c93c2-ff56-4c0f-9a38-2198aa697d49	85	264	Course 24	Provident sint molestias pariatur qui ipsa est officia minima. Commodi quis perferendis inventore accusamus. Nostrum minus est rem vel voluptate qui dicta eius. Sit sunt laudantium aperiam natus voluptatem id veniam. Explicabo et voluptatem veniam delectus magnam perferendis quis. Voluptatem voluptas corporis ea fugiat quae non magnam. Quo aut nihil ut eligendi sit at praesentium. Enim at saepe nesciunt sint ut possimus doloremque fugit. Quos sed sunt animi corporis. Ut necessitatibus maxime sit et pariatur suscipit et.	/images/course_example_image.png	approved	\N	54.21	3.68
a81103d1-af0b-4a2a-896f-83f0d66a994f	5966bf52-d026-4fb4-8d6a-0b99c02d8144	85	287	Course 25	Ut saepe deleniti consequuntur. Sunt quis assumenda accusantium at eligendi. Quidem et est rerum fuga libero. Autem reiciendis culpa recusandae. Molestiae voluptates consequuntur officia quaerat qui cupiditate. Omnis mollitia nulla commodi. Voluptatem quasi dolor dolorem voluptatem in. Occaecati eum occaecati sed qui. Debitis cupiditate sunt praesentium aut assumenda nisi perspiciatis atque. Adipisci quia voluptatibus dignissimos aut ea.	/images/course_example_image.png	approved	\N	79.9	3.75
27f59a2a-ab6e-4f88-9aab-a995fc2c7700	7a26f752-850e-4def-b08f-8e391d5a51c4	85	297	Course 26	Praesentium amet eveniet minus voluptates. Temporibus commodi est iure aut voluptates. Quos perferendis molestiae in inventore placeat. Animi porro atque perferendis rerum et. Rerum maiores voluptatem harum deleniti sunt eum. In eius non quia eos sequi. Consequatur ut sed exercitationem sunt. Ipsa architecto id modi provident. Qui possimus repellendus minima. Qui deserunt eveniet qui officia.	/images/course_example_image.png	approved	\N	82.06	3.82
6196d85c-3a4e-470c-9ded-5575406039a5	756599b6-343e-43d8-880b-ca9fa56efc94	85	280	Course 27	Cupiditate sed sit rerum nemo voluptas. Iste consequatur ut ut voluptatum. Mollitia alias fuga eum nisi laboriosam. Accusamus velit illo eveniet occaecati commodi. Est rem sit repudiandae possimus. Cupiditate impedit corrupti temporibus ipsa sapiente quos commodi. Deserunt recusandae in eligendi ullam. Ea a qui reiciendis quo rerum quasi enim. Magni voluptates voluptas cumque illo voluptatibus magnam sed. Praesentium nihil labore voluptatem.	/images/course_example_image.png	approved	\N	91.87	4.02
9beb1e2f-b8e8-4ec7-9357-aea56de48c5f	7af90bc1-a89c-42ea-9d25-61312b0bfc80	85	324	Course 28	Dolor ipsa distinctio sit non sint et. Quam qui pariatur placeat voluptatem qui. Magni at facilis autem dolores saepe quas. Corrupti dolorem accusamus ipsa laudantium. Deleniti necessitatibus ut corrupti eos molestiae. Quasi cum accusantium aut placeat iste ea et perspiciatis. Rem nihil fuga autem in rem iusto. Sunt asperiores at esse est. Omnis voluptatem quod repudiandae dolorem. Atque dolore voluptatibus quia vel.	/images/course_example_image.png	approved	\N	91.67	3.45
8e765044-d70d-467f-be8d-7c14d6ab7d88	1b527bae-1776-4e97-811a-e6ee0ac9b856	85	292	Course 29	Quibusdam deserunt perferendis molestiae accusamus. Molestias non quos reiciendis quisquam mollitia. Aliquam dolor adipisci temporibus nobis ullam eos odit rerum. Sint ducimus reiciendis consequatur pariatur sed. Voluptas amet magni est velit repudiandae officiis laudantium qui. Repellat sint ipsa id quia delectus. Ut aut ipsum nostrum nesciunt est. Velit accusamus reprehenderit porro qui voluptas animi ullam. Voluptas voluptatum enim molestiae distinctio ut totam. Ullam voluptatem esse vero quam quo eligendi explicabo.	/images/course_example_image.png	approved	\N	98.31	3.39
da2dd6cc-aa55-4f5d-9b3c-b6ea19a2e40c	b462562b-2f98-4f26-bec1-1b8eb04bd14e	85	274	Course 30	Inventore quia enim itaque iure. Repellat velit maiores aut harum dolor dolores aut. Voluptate qui ut labore culpa ea non. A ducimus temporibus explicabo. Nihil deserunt ea illum ipsum veritatis est numquam. Iste nisi dolores et fuga omnis quos aliquid sapiente. Placeat voluptate qui magni aut quibusdam. Dolore nihil voluptate atque non. Magni iste porro explicabo quo. Nam officia culpa dolor est enim vero doloremque.	/images/course_example_image.png	approved	\N	83.01	4.68
4003c42b-cc0a-404b-baa3-593ce7978540	2002c367-7681-4ff6-9d7a-aeb9f372848d	85	305	Course 31	Dolorum placeat recusandae quaerat quis. In alias distinctio fugiat tenetur. Aut inventore nesciunt et consequatur inventore aut. Earum omnis iste iste ut qui. Ratione et laboriosam iste in illum expedita. Ut animi eos tempore laborum perspiciatis eum accusantium. Aliquid sit voluptatem et ut aut. Dolore aut culpa quas nam ut cupiditate minima. Quas architecto hic ut et illo aut et. Libero dolores illo quia sint beatae sed quis sed.	/images/course_example_image.png	approved	\N	54.79	4.21
cb2105be-1020-47d2-a633-324b272da44b	08344e18-07fd-48b1-9ed0-859cea43b0c1	85	269	Course 32	Nobis totam dolores eum et vero sapiente. Sequi sit nisi dolorum quo ipsa eos quo. Minus eum consectetur quo aspernatur consequatur cum. Dolorem earum est nam fugit. Sint quo nesciunt sed inventore officiis. Porro ut similique earum accusantium voluptates. Porro rem modi et iste quo. Molestiae minima amet sit corporis. Natus eum ratione a vero qui qui eos. Veritatis voluptate distinctio vitae dolorum voluptatibus totam ratione.	/images/course_example_image.png	approved	\N	92.19	3.88
ea02cb59-bdb7-47be-ba67-b7e2ced46b94	0f26c98c-376d-49de-9633-7fe4899f67f8	85	320	Course 33	In animi eum ipsum minus ut laborum. Nulla et molestias error dolor. Atque laborum iste voluptas dolorum. Iusto aut nostrum doloribus tempore aut dignissimos error culpa. Libero aut deserunt reprehenderit nisi. Qui voluptatibus alias dolor ut ut. Quis reiciendis quos aliquid commodi. Porro qui sint qui perspiciatis omnis recusandae cum facilis. Ullam est et mollitia earum. Nesciunt ipsam asperiores et id in saepe officiis.	/images/course_example_image.png	approved	\N	67.26	4.09
2177fe92-c93d-4001-bb5e-d32311de4c68	8f41dec1-420c-44f5-ab60-f5e35d921efb	85	304	Course 34	Sapiente veritatis natus quidem dolores modi. Reiciendis voluptatem possimus atque cupiditate. Recusandae quis exercitationem est non quis. Quos omnis dolores assumenda recusandae harum delectus commodi possimus. Quis ullam dicta consequatur inventore adipisci qui. Ut eveniet qui accusantium voluptatem voluptatem quam. Animi perspiciatis non aperiam sed qui ea quia. In sed facere nisi quaerat. Vel blanditiis et in magnam repellendus. Beatae veritatis dicta esse nostrum dolorem porro ratione.	/images/course_example_image.png	approved	\N	74.56	4.04
58c30af1-af58-4d43-91c6-bb99e898801e	c1bd639a-ebd9-4af1-82b8-b28797a22aac	85	318	Course 35	Enim facere est et ipsam voluptas aliquam ut. Ullam ipsam nihil dolorem voluptas esse eaque aut. Non nam dolorem ut ipsam optio similique et magnam. Occaecati amet exercitationem non vitae quae inventore. At est praesentium ea qui voluptate. Eligendi quod rem ut itaque provident et sunt. Voluptas possimus voluptates harum sint velit tenetur. Quasi voluptas ipsa est velit. Tenetur vitae id velit sint et perspiciatis nobis. Voluptas quidem consequuntur eligendi reprehenderit non rerum optio error.	/images/course_example_image.png	approved	\N	61.47	3.56
1e7bdeba-d440-47a7-b000-de54ac4500d7	ee917493-50c9-4f94-bd87-f416bf21593d	85	275	Course 36	Sunt qui et corporis dicta aut ea quaerat. Voluptatem fugit et excepturi dolores voluptas. Velit provident rerum vel possimus unde. Perspiciatis explicabo enim aliquam ut ut possimus repudiandae. Laudantium officiis eos nesciunt et doloribus fugit. Nemo officiis explicabo qui nobis. Ut est repellendus eaque nemo facere et quisquam labore. Voluptatem iusto quis similique beatae vel. Iste asperiores architecto qui consequatur. Nam nihil ut rerum ipsa.	/images/course_example_image.png	approved	\N	90.52	3.29
236d3473-00fe-426c-b2a0-c85942cc0ac4	073756d8-3eff-4831-a1ae-4323f1d2aea8	85	275	Course 37	Ea iure ad dicta reiciendis error. Explicabo eius et non rem. Dolorum ea asperiores reiciendis perspiciatis veritatis. Qui adipisci iure nemo ut qui eius. Facere officiis non deleniti maiores. Modi doloribus perspiciatis repellat. Minima voluptas est veritatis ullam. Magnam asperiores autem quia error sunt vero. Fuga et non cumque perspiciatis asperiores quaerat. Unde at dicta et beatae eius.	/images/course_example_image.png	approved	\N	58.53	3.87
cbf45cfc-9d2e-42dd-b1fb-2c67b6c0cd23	ee972a66-db08-4fe5-bf26-b607701a9d7a	85	315	Course 38	Est nemo explicabo quia vel voluptatem. Ut laborum qui sint impedit id excepturi ad. Vel ad libero nulla laborum. Culpa magnam dolorum nostrum qui libero quia. Veritatis quibusdam et exercitationem. Veniam molestias earum perspiciatis quam vero ducimus. Minima quo deserunt cupiditate. Minus optio animi enim dignissimos voluptatem eligendi. Id non sed itaque et voluptatibus iure. Aliquid nobis animi aliquam laboriosam nisi voluptatem voluptas.	/images/course_example_image.png	approved	\N	92.06	3.34
df1391d8-6f71-4f6c-9fb8-3050f1093ddc	d15c3de1-b9e4-4e27-84c1-60a540dcbe40	85	295	Course 39	Ex nisi sit autem consequuntur molestiae sunt voluptatibus. Quidem commodi explicabo voluptates qui. Rerum cum eos dolore consequatur id. Dolor voluptatem fugit dolor. Excepturi nam occaecati aut cupiditate voluptates vitae temporibus. Quo culpa voluptatem nesciunt nihil nesciunt sed et. Iure et praesentium aperiam in. Quia exercitationem atque facere repellendus rem. Dolorem eligendi aut tempora repellendus consequatur. Dignissimos sit dignissimos ipsam.	/images/course_example_image.png	approved	\N	75.43	4.35
21a4bba5-85f6-4273-a99c-e118fcea4e5a	4de728ef-3d78-4551-a568-2066c8285c96	85	287	Course 40	Optio porro sunt tempora. Soluta sit corporis et voluptas. Voluptas perferendis non architecto omnis et et. At similique dolorum quos iure pariatur minus itaque. Dicta qui rerum aut cumque dignissimos illum. Architecto optio vitae voluptas unde voluptate excepturi numquam. Ut rerum assumenda error animi. Dolor consectetur ipsum eum consectetur sed. Illo saepe cum expedita. Iusto consequatur qui quis laborum nesciunt delectus quia.	/images/course_example_image.png	approved	\N	52.73	3.77
c97a62f6-542f-473f-b206-1a3a78285500	bd8fbf79-2de0-40cc-8aa1-d75a75163919	85	313	Course 41	Voluptas architecto totam error iusto. Sunt neque debitis quos architecto non ut non. Nostrum dolores nobis voluptatem accusamus cum. Modi vero eum assumenda ad et vitae in. Exercitationem eligendi animi facere qui neque quis sit. Ut voluptas ex et rerum ut itaque eius. Laudantium natus modi laudantium exercitationem aut eveniet minima. Ullam enim cupiditate ea rerum. Doloribus doloribus eaque amet. Eum maiores sed molestiae.	/images/course_example_image.png	approved	\N	93.53	4.56
488f047e-9c93-4abb-ad67-78a5ddbfeb1c	e17d877e-f91b-4d36-84cf-32a64ec7c629	85	293	Course 42	Cumque eligendi aut voluptatem sint quis. Facilis temporibus asperiores iste dicta et dolorem. Error et ipsum accusantium rem quibusdam animi. Eum aut facilis magnam aliquid nihil vitae nesciunt. Est illum nemo rerum corrupti officia provident magni consequuntur. Suscipit quidem veniam et autem modi consequatur. Eligendi sunt ea consequatur. Omnis est in quo sed. Quia voluptatem minima est odit quos qui. Expedita aut iusto aut itaque facilis nostrum consequatur.	/images/course_example_image.png	approved	\N	91.26	4.15
a53c6cea-7453-4a6b-9236-da8e33b5c586	12d5a16e-acf3-406c-ae67-94548005162b	85	323	Course 43	Illum sequi minus dolor impedit repudiandae cum qui. Odio tempora ipsum dolorem quisquam. Necessitatibus labore labore beatae quam quia. Qui ducimus optio quis natus id. Atque sit nostrum officiis repudiandae. Eius dolor voluptatem ex dolor autem ea. Adipisci ratione quaerat animi. Consectetur aliquam voluptatem inventore neque. Consequatur autem magni ducimus fuga eos blanditiis. Aut asperiores dolores fugiat.	/images/course_example_image.png	approved	\N	98.87	3.38
16311b62-0a57-4430-9b27-86c62eb3670d	882dbe79-7285-42e6-bd84-ec4826060010	85	279	Course 44	Numquam magnam neque accusantium dolores. Voluptatum hic voluptatem beatae laborum optio praesentium. Beatae deserunt recusandae qui molestiae cupiditate. Reiciendis labore harum ut id fugit. Et a sunt eaque facere ullam in. Pariatur aut praesentium nihil laboriosam. Nobis incidunt quidem iusto omnis in delectus doloribus excepturi. Cum et amet officia modi sed ipsam ut laborum. Autem iste at itaque cupiditate labore ut. Alias autem cum ut impedit earum.	/images/course_example_image.png	approved	\N	72.57	3.05
098a18c2-1d38-4c4b-9cb7-09223e3f8f56	429218cb-6972-43f2-add7-8029d17119ab	85	307	Course 45	Beatae aliquid qui id ipsa laudantium minima ut qui. Error in rerum recusandae voluptatem. Consequatur quasi quis quae provident. Et itaque aut hic eaque est et est. Id necessitatibus quod et aperiam consequatur laudantium modi. Cum aperiam quos aliquid est quasi mollitia explicabo. Aut aut ut aperiam voluptatum. Odit illum quos nihil expedita. Quos odio deserunt et et et id nihil. Dolor sint id est perferendis delectus.	/images/course_example_image.png	approved	\N	71.42	3.11
0a194dec-d1da-45a8-98e0-5889d44bbf37	c28f47fb-efdf-41f4-9625-04755f3aceab	85	289	Course 46	Atque eveniet omnis et qui est omnis voluptate dolores. Consequatur eos expedita molestiae sapiente sit sunt. Ipsum totam ducimus voluptas sit qui. Ut illum aut molestiae. Est deleniti sint unde impedit quae possimus. Consectetur ipsa asperiores ipsam maiores excepturi necessitatibus. Architecto voluptas ab et rerum quo. Numquam asperiores qui sint aliquid consequatur suscipit est. Temporibus qui nesciunt non laudantium repudiandae. Cumque tempore laborum dolores alias et illo laborum vel.	/images/course_example_image.png	approved	\N	72.86	3.01
b3ee653e-91d2-4351-a21f-2428ff78a784	c3e158df-9779-4e7e-9ac5-6b2c607b741b	85	292	Course 47	Enim saepe repellat aspernatur quia similique. Et rerum ut vitae doloribus accusantium tenetur. Ut corporis quia dolores iste sit. Velit nobis adipisci qui qui optio doloribus vel. Qui est veritatis ipsa ut vel blanditiis illum. Incidunt aperiam laudantium repellat mollitia. Fugit asperiores voluptatem sit fugiat alias est maiores consequatur. Dolorum quae dolor autem perferendis est incidunt magni. Qui aut voluptatum dolores dolor possimus enim quia rerum. Culpa voluptatum doloremque iste laudantium possimus sed.	/images/course_example_image.png	approved	\N	61.52	4.81
a0ecfe54-867d-4a4e-b9e1-239db095307f	7b633950-129b-4cb7-8a31-0f52114793ab	85	325	Course 48	Esse modi ad eum sit quaerat odio facere. Impedit doloremque eos adipisci sint quia aspernatur. Aut animi et voluptates dolor. Omnis et dolores perspiciatis et nisi sint dolorem incidunt. Ratione voluptates dolore fuga perspiciatis rerum. Quis animi aperiam praesentium illo consectetur. Et dolores non itaque. Est in enim quidem quo vel culpa sed. Culpa in iusto voluptatem at. Est iste velit qui illo alias.	/images/course_example_image.png	approved	\N	74.51	4.63
75b02db1-9c75-45b0-9afe-5595502f9402	f3d647d4-1002-4358-9a7a-fcf1c3691b39	85	265	Course 49	Nihil molestiae voluptatem corporis autem eligendi officiis. Debitis libero et at rerum sit inventore ipsam ut. Recusandae et vitae qui est. Aspernatur libero quia veritatis iusto exercitationem sint. Necessitatibus quam ex minima ut odit non culpa earum. Fugiat veritatis numquam veniam rerum est. Repudiandae dignissimos voluptatem deserunt rem cupiditate. Atque qui est earum nihil dolores ducimus numquam. Est dolorem veniam natus porro laboriosam ipsum. Numquam error aut quia est praesentium non fugit.	/images/course_example_image.png	approved	\N	79.64	4.86
e2b7c840-9ddd-43f6-a20c-7dedbfc4f2b8	3387ba2b-24e8-47e5-bd7e-cbe61c6136ad	85	275	Course 50	Est eum ipsam impedit animi iure odio. Similique non beatae et tempore et voluptatibus et delectus. Sed tempore iste ut reprehenderit. Sed hic necessitatibus minus nulla occaecati. Consectetur qui ducimus maiores sint. Magni distinctio soluta et quis. Ut harum aut a nihil explicabo qui. Distinctio qui libero reprehenderit quibusdam ab. Dolorem architecto sed sunt deserunt quia nobis. Delectus ab ea repellat unde nihil excepturi voluptatem sapiente.	/images/course_example_image.png	approved	\N	76.82	3.01
9948c34e-6784-4616-aaef-573ca842f3cc	77e75adb-20e4-495c-beeb-98f275b8224b	85	308	Course 51	Dolores qui officia cupiditate expedita sapiente. Reiciendis fugiat qui suscipit qui et optio voluptatum iste. Sit eum perferendis perspiciatis vitae quaerat porro. Dolores dolores dolores quas voluptas doloremque expedita distinctio. Aspernatur sit iure voluptas tempora beatae quo tenetur. Inventore nihil nam eos aut veniam sint. Earum nobis illo sed deleniti. Incidunt omnis atque molestiae. Consequuntur vero sunt ab labore. Minima fuga voluptatibus molestias quia aspernatur sit expedita aut.	/images/course_example_image.png	approved	\N	89.95	3.89
c87126a9-6906-4831-be96-d8581de45e23	285bafd9-3fd1-4812-bd1e-1eb54abd8d15	85	289	Course 52	Temporibus magnam qui corrupti laborum ullam natus et et. Culpa nisi vel iure rerum deleniti sequi quo quos. Voluptas autem ipsum dolorum excepturi. Fugiat nihil saepe consequuntur autem odit. Reiciendis omnis dignissimos ut voluptatem eos dolor. Consequatur voluptatem animi dolorum accusamus qui ullam. Voluptates voluptas quasi esse sapiente aut non. Voluptas dolores omnis nulla ut et. Error dolorum quia iusto fuga. Tempore nostrum nisi sapiente.	/images/course_example_image.png	approved	\N	95.65	3.17
ff86a6c0-1ab8-4d99-b93d-cee1ba1daa9d	0ac35814-5b07-4219-aa80-89c7c6fd3cc8	85	288	Course 53	Id deserunt voluptatem neque eos veniam. Exercitationem ipsum asperiores numquam perspiciatis aut. Qui est maiores aut error libero enim et. Vel non voluptatem corrupti laboriosam iure. Atque quae esse ut eaque. Molestias assumenda molestias sequi sunt. Sint nulla non aliquid consequuntur consectetur sint quas a. Illum numquam aut voluptates corporis dolor consequatur. Laboriosam voluptate in vel libero. Exercitationem minima laboriosam non et velit neque explicabo.	/images/course_example_image.png	approved	\N	52.4	4.79
25291e8d-6051-47b6-9836-0ea5ec6dd227	1f99e13f-acd6-4f7a-93ce-8fcad70bca45	85	275	Course 54	Iste aspernatur quos ullam dolores nobis harum tempore. Ab non quae placeat aut sed id. Quos omnis aspernatur qui dolore qui deserunt neque omnis. Repudiandae nesciunt beatae voluptatem qui aut totam inventore. Voluptatem vel hic aperiam impedit nisi quae. Voluptatem et iure quod quia voluptas numquam omnis. Quae rerum facilis a dolor similique dolores explicabo nostrum. Consequatur labore odio est consequuntur perferendis nostrum voluptas rerum. Neque earum accusamus inventore occaecati. Distinctio quod exercitationem numquam repudiandae occaecati ut in.	/images/course_example_image.png	approved	\N	73.92	3.96
06de03ef-b26e-414a-9fd6-a3755b688040	3e2ccf51-53e2-4d47-9749-278b0c906d25	85	325	Course 55	Illo aut sunt perspiciatis vel quisquam ut. Est dolor dolor voluptate nesciunt in quis. Qui ut distinctio et ratione recusandae. Ut consequatur et molestiae iusto qui. Rerum et consectetur ratione nihil minima aut. Libero molestiae omnis unde consequatur quis iusto numquam. Veniam commodi dolorum reiciendis rerum et laborum. Dolor sed temporibus saepe quisquam ab. Reprehenderit delectus libero reiciendis vero dolorem ut hic. Corrupti molestiae quia corrupti aut.	/images/course_example_image.png	approved	\N	55.53	4.99
8c05c8fa-6112-4e0b-98f1-10133da37dd2	3e2171bb-4900-44dc-95a6-b90778f25513	85	277	Course 56	Possimus ea et ullam in at aut ipsum. Nemo aut eveniet rerum similique earum saepe pariatur. Est est quis neque vel aperiam. Et sunt atque est qui et quo. Sint ipsa inventore itaque nihil. Optio mollitia similique quis sit molestiae. Maiores quis quia rerum rerum eum. Rem suscipit cumque deserunt repellat similique et atque. Eligendi quibusdam qui iusto assumenda similique. Exercitationem cupiditate numquam quisquam.	/images/course_example_image.png	approved	\N	55.15	3.94
ae7eeb1a-2aa0-4d61-8a2d-de4fa75e37bc	180b0506-c433-4118-a5d5-b8f1d67e12c5	85	284	Course 57	Qui quis quis praesentium aut est. Ad nesciunt nemo voluptas excepturi fuga et omnis. Rerum ea ipsam repudiandae explicabo. Ut necessitatibus et sint maxime repudiandae commodi nisi voluptas. Ad magnam laboriosam sint accusamus neque neque. Illo aliquid hic inventore omnis. Consequatur beatae voluptatum aliquid perspiciatis hic autem repellendus eius. Id placeat natus quis doloribus corrupti minima autem ex. Incidunt aut ad cumque fuga repudiandae ut dolorum. Alias accusantium sint nesciunt possimus.	/images/course_example_image.png	approved	\N	60.7	3.92
42d1389d-220f-49c0-b54f-93f2b6e9fe93	2ee89b82-742d-401e-b50d-0f56d836ebd1	85	280	Course 58	Sit commodi id tempora minus amet. Itaque quo quasi quaerat mollitia excepturi sint et consequatur. Dolorem molestiae similique dolorem voluptas aliquam. Nihil et rerum enim doloremque earum veritatis. Neque nesciunt eaque cupiditate enim velit qui maxime. Enim non sint distinctio sit perspiciatis exercitationem. Et reprehenderit autem temporibus velit. Qui vitae inventore id facere perspiciatis necessitatibus laboriosam repudiandae. Nam est quod itaque optio laborum ex. Et perferendis quia totam eos.	/images/course_example_image.png	approved	\N	73.33	3.57
d186a20d-669d-4cab-a160-c5101b7634ce	7c81dcdb-d6cb-4178-81cb-786c910a4b28	85	304	Course 59	Rerum harum ratione sapiente voluptatem. Ea aut vel vel praesentium natus. Magnam fugiat quia aut provident. Nostrum est laboriosam incidunt doloremque voluptatem dolores soluta. Quis inventore nisi rerum aspernatur consequuntur. Nam et consequuntur rerum voluptatem. Qui ipsam sed quaerat. Quia nihil eius delectus alias sapiente harum nobis. Dolores et praesentium quod ducimus eligendi qui laboriosam. Dolores dolorem et modi voluptatem et.	/images/course_example_image.png	approved	\N	96.68	4.88
12693722-7648-44fd-97d5-bd53f5f10915	2bcd374c-0933-4f1e-a0f7-1cdc369cf820	85	268	Course 60	Deserunt exercitationem inventore expedita doloribus quia quis nulla. Nostrum quaerat expedita distinctio nisi non tenetur. Asperiores voluptas enim commodi. Quasi ut accusamus ut doloremque sed et quidem. Aut qui voluptatum enim cumque modi. Enim quod molestias eius ut a officiis facilis. Fuga et consectetur expedita dolores. Nihil voluptates consequatur perferendis itaque. Et aut enim quaerat et ea. Voluptatem vel dolores officiis adipisci ducimus laborum nihil numquam.	/images/course_example_image.png	approved	\N	81.8	3.19
86051fcb-c598-4d30-9876-f1b0ff0e01d7	cc1fc1a2-b893-4cb3-a2d2-5872903a06eb	85	323	Course 61	Cumque ex ut libero suscipit qui aliquid et. Qui mollitia optio numquam doloremque et aspernatur et. Cupiditate autem excepturi nihil est. Cumque a assumenda id occaecati. Reprehenderit distinctio nihil animi. Natus sit eaque optio repudiandae. Ad non sit quaerat. Nisi repellendus velit in est alias et. Doloremque quia et aut tenetur esse eveniet sunt. Aperiam aut sit et eos.	/images/course_example_image.png	approved	\N	89.47	3.89
f68deca5-13ec-4365-afcc-c2211c0087e5	2a60da79-bdd8-48cd-8368-d6cb8726ca33	85	283	Course 62	Temporibus mollitia eius debitis rerum ut ea. Ut optio ut dolorum illo. Neque officiis ratione consectetur nihil sapiente ea quae officiis. Aut velit maiores rem modi adipisci laudantium rerum. Nihil non quidem quia unde. Perspiciatis qui at similique adipisci alias autem soluta aut. Error nemo et quasi laudantium nostrum. Sint velit iure eligendi possimus temporibus voluptatem. Minus suscipit officiis quo. Numquam non cum officiis laboriosam.	/images/course_example_image.png	approved	\N	52.17	3.4
6103ed90-5ed7-41d4-95d3-1a828a634dee	6268f659-b7a7-4d6f-a9c1-7a539bbf2666	85	317	Course 63	Aspernatur non id aut. Quisquam mollitia eius fugiat. A molestiae laboriosam deserunt et voluptas. Et ut veniam sunt non. Eum perspiciatis sequi veritatis corporis aut. Voluptates fugit dicta est quia. Voluptas voluptatem aut cumque quo tempore corrupti. Sunt libero omnis et corporis et. Beatae minima velit commodi suscipit velit. Illo incidunt at incidunt quae.	/images/course_example_image.png	approved	\N	60.61	4.35
b99c82e8-e255-4022-a2a8-5da96945dbd5	83af701f-37b5-419d-b9a7-ab0b6a303881	85	297	Course 64	Necessitatibus fugit harum hic nihil qui recusandae. Incidunt ex voluptatem et. Qui fuga unde voluptatem amet et unde ratione. Aperiam nisi ad et expedita commodi porro a. Necessitatibus aut et vel et aut dolor nam. Et harum pariatur aspernatur dolor et animi iste. Reiciendis qui error autem et. Nemo magni sed quasi corrupti fuga velit in. Rerum est quo et ex sed mollitia a voluptatum. Molestiae odio voluptatem ad quaerat voluptatum.	/images/course_example_image.png	approved	\N	94.53	4.5
a3924cbc-2e50-419c-99ec-b6d2f1ea4972	cfb9b5d7-679b-4ffc-bdd7-c0a5ba87d0e0	85	283	Course 65	Aliquid maiores alias omnis magni in consectetur. Cumque quo repellendus mollitia velit maiores qui. Blanditiis natus ullam consequatur voluptas temporibus. Laborum repudiandae rem omnis dolore et praesentium iste. Velit accusantium aperiam nulla adipisci harum alias. Dolorem incidunt unde voluptate quam eius et dolor occaecati. Quia corporis nobis amet iste aut magnam. Rem blanditiis earum officiis quia molestias vel. Earum fugit eos aliquid vitae maiores. Numquam perferendis autem similique odit velit accusamus.	/images/course_example_image.png	approved	\N	71.93	4.07
bc7e166e-ca50-42fb-b74d-f873fd910584	9bc67eda-a78a-46f7-9dc4-f32933a7df80	85	282	Course 66	Cum non quaerat debitis tempore libero omnis distinctio totam. Qui cum et consequatur dolorum. Sunt labore at enim adipisci architecto aut cupiditate. Rerum quia praesentium sit occaecati delectus quia. Dignissimos iure in ullam et voluptate non cum. Iste aut iusto eligendi mollitia. Praesentium occaecati eos nemo maxime ut quod. Nobis soluta excepturi pariatur maxime quisquam deserunt placeat nihil. Qui quidem dolorem impedit et dolores quaerat adipisci quod. Voluptatibus facilis cumque similique non asperiores cumque.	/images/course_example_image.png	approved	\N	89.19	4.95
930051ba-593b-4149-b803-91692f741642	3b6fe60a-4659-48b8-bbb1-ed3bd62f148f	85	263	Course 67	Dicta suscipit autem consequatur. Esse dolores repellendus beatae in dolorem eius iure nihil. Sit dignissimos ut aut ut enim. Soluta suscipit odit ea voluptates ut nesciunt eius omnis. Quibusdam sit est provident corporis. Odio beatae occaecati repudiandae doloribus iure non quibusdam. Explicabo accusantium necessitatibus animi soluta maiores et alias. Quis necessitatibus explicabo cupiditate exercitationem. Laborum qui tenetur repudiandae error aut natus aperiam. Et molestiae occaecati velit accusantium sed.	/images/course_example_image.png	approved	\N	50.7	4.2
abf90775-1815-4c94-a9d0-1c67c175bc9b	0c197781-d730-478e-9fc6-c2905a1912c8	85	264	Course 68	Necessitatibus magni aut ut repellat. Enim sunt aut ut itaque. Non et aut qui sequi quis consequuntur. Enim vel facilis sunt dolorem architecto. Perspiciatis quo alias sunt. Debitis id et aliquid earum dolorem. Magnam id atque reprehenderit est iure. Et qui ut molestiae soluta. Magni non ut consequatur ea velit. Vero et aut veniam tempore eaque fugit sint distinctio.	/images/course_example_image.png	approved	\N	71.48	4
f6e96946-0f42-4dc6-b0f4-c209898c4917	9e03071f-7301-4f4a-80c8-797630dd28e8	85	264	Course 69	Ut consequatur optio quasi natus. Autem voluptas magni eveniet sit ut et hic. Sint dolore assumenda earum aliquid. Quis est vero sunt est. Illum hic et ad et optio exercitationem consectetur omnis. Odio magni fugiat aut natus recusandae consequatur. Molestiae illo est magni ut quasi. Earum quod at deleniti qui suscipit temporibus sit voluptas. Dolorum minus rerum non iste aut nesciunt. Hic et omnis aut numquam consequatur.	/images/course_example_image.png	approved	\N	62.42	4.14
9fff4c10-bed3-4c50-b9ee-88f8aa62430e	53f0a77b-a476-4b20-b462-7b8d6c3d8ae6	85	289	Course 70	Aut vel voluptas nesciunt odit. Magnam ut quis sequi aut commodi et dolorem recusandae. Repellat sequi cupiditate ut nulla et culpa illo amet. Aut delectus sit qui et. Non magnam dolor rerum ducimus. Cupiditate dolor aut fugit excepturi. Ipsum impedit et omnis sit. Debitis neque eligendi iusto tempora. Non qui ut ut quasi doloribus laboriosam a. Et dolorum aperiam beatae corporis quis provident molestiae voluptas.	/images/course_example_image.png	approved	\N	78.73	4.71
33baab00-b052-43f2-b1e2-271ea16f9970	04980870-e5b6-49e5-8b37-480beb6ff656	85	312	Course 71	Sed nihil odit quam voluptas. Est accusamus pariatur voluptas ducimus accusamus vitae quia rerum. Ex omnis corporis soluta rerum doloremque dolores et. Voluptatem quia incidunt et alias dolores. Placeat sunt delectus temporibus aperiam illo et. Blanditiis aliquid ad error. Nulla architecto vitae atque officia. Corrupti omnis dignissimos iusto ex. Deleniti laudantium reprehenderit consectetur est corrupti asperiores. Cum a expedita aliquam natus nostrum.	/images/course_example_image.png	approved	\N	96.34	3.44
3ce309ee-6109-4946-8872-89fe0d0140e3	f531ef61-3e84-4abb-8141-f98bf006d189	85	307	Course 72	Ea numquam suscipit nesciunt magni deserunt quidem cum. Non nesciunt accusantium ut quis sint voluptas quia. Praesentium et dolorem nisi placeat nesciunt recusandae. Laboriosam mollitia in non at recusandae. Ut voluptatem est molestiae aut exercitationem. Consequatur officia quidem dolorem eum facere omnis blanditiis. Voluptate eum ut nobis quidem. Nemo quia est omnis voluptas saepe ad dolorum esse. Ab ut enim ea voluptas. Voluptatibus voluptas aut in rerum sit beatae.	/images/course_example_image.png	approved	\N	94.35	4.2
49f30d13-f21e-4ac4-99ca-34f79df18122	57c654cb-b1ae-429d-bacc-c38c565d219d	85	304	Course 73	Voluptatibus dolores vel sit quo dolore incidunt. Repudiandae nostrum et dolores. Qui et et atque similique. Ipsum cum dolor dicta error enim corrupti. Rerum praesentium facilis cupiditate omnis. Quae autem quas iusto in qui minima doloremque. Labore ab qui facilis sed. Et itaque alias distinctio quo incidunt necessitatibus ut. Eos facere provident ipsum qui mollitia soluta est. Praesentium voluptatem quia quia nihil.	/images/course_example_image.png	approved	\N	84.89	4.2
587e82e0-0760-42f8-b9cd-ce35ef7ceaa9	9d090d0b-14c3-4b03-b4cf-094c1f5189f0	85	302	Course 74	Neque assumenda nesciunt quae rem nobis. Quisquam facere in et dolorem. At itaque eos ullam necessitatibus tempora voluptatum quis. In iste mollitia vero nisi aspernatur voluptatibus cumque assumenda. Perferendis et cumque ab molestias ea aperiam. Ipsum consequuntur excepturi ut enim laborum. Sed sequi qui fugiat at qui perspiciatis rerum enim. Non dolorum sit reiciendis minima ut tenetur dolore. Consequatur accusamus eum dignissimos. Est consectetur quo natus est blanditiis eum quo.	/images/course_example_image.png	approved	\N	60.24	4.18
4b3189bd-8fce-4fa8-8c68-06c370f15b92	915779e6-d6d4-4c90-89da-9f558a9d847f	85	323	Course 75	Excepturi nostrum atque consequatur ducimus quo perspiciatis. Iste pariatur adipisci est molestiae rem dolorum earum. Eos eos accusamus quidem aut rerum exercitationem. Dolores ut excepturi eius omnis est accusantium. Unde ad similique porro quis delectus. Explicabo et quo nihil. Ipsum est quibusdam expedita repellendus libero ducimus. Alias exercitationem repudiandae doloremque et quis alias deserunt. Qui deleniti minima commodi est quasi sed quod inventore. Earum vero nisi quis omnis dignissimos ut ducimus.	/images/course_example_image.png	approved	\N	81.66	3.68
742b4e07-382e-430b-a02e-76495e416ae5	713a15cc-20e5-4f0f-874a-a8d27b356ba7	85	309	Course 76	Qui et commodi voluptas. Eum ad velit minima soluta velit eum. Cum quis a sit architecto. Laborum voluptas qui et quisquam. Id consequatur cum consectetur. Quos ad minima sint iure incidunt qui voluptatem. Deserunt quos enim architecto exercitationem. Nesciunt neque rerum vel alias. Doloremque rem et ea enim. Vel quo voluptatem eius aperiam saepe nulla consectetur.	/images/course_example_image.png	approved	\N	84.69	4.64
3eedf253-b6c9-405d-b971-66c90cd18547	b8874757-3a3d-4e72-a53f-180fc523b538	85	279	Course 77	Impedit dolor quas amet ut error. Et voluptas numquam aut aut. Totam tenetur dolore voluptatem explicabo reprehenderit aut quisquam. Illo omnis temporibus dicta. Nobis enim dicta aut quo repellat eligendi temporibus voluptatem. Aut est nemo nemo quae. Voluptas sunt illo perferendis autem esse. Ea sed voluptatibus praesentium reiciendis facere iusto. Mollitia perspiciatis architecto et sapiente atque quaerat itaque. Quas autem dignissimos omnis ut consequatur molestiae voluptatem.	/images/course_example_image.png	approved	\N	88.16	3.26
142ae327-f5f1-4d4c-8823-899a7f78a102	fbf834ef-ea76-4aed-986e-bd199f342a21	85	272	Course 78	Reprehenderit cumque nisi sint culpa voluptatem quis reprehenderit. Voluptate illo ipsum vero harum ea totam. Et illo ducimus impedit voluptatem rerum. Facere accusamus quis placeat. Excepturi quo accusamus dolorum rerum quaerat. Omnis placeat adipisci reiciendis in doloremque. Qui quia incidunt expedita nihil a saepe. Praesentium porro excepturi totam sit eum omnis. Tempora ut autem necessitatibus quasi dolor doloribus laudantium. In cum veniam ex est aspernatur accusantium.	/images/course_example_image.png	approved	\N	67.51	4.13
d2a1da64-937c-46ea-9e50-ad9f24fc8cec	2ba099a5-26a2-4426-a820-5b38803e8a95	85	279	Course 79	Exercitationem ad nihil odit hic modi. Et praesentium iure deleniti reiciendis itaque corrupti. Quas amet asperiores quidem qui dolor ipsum. Quas consequuntur aut fugiat magnam quod quos molestiae sed. Modi inventore quo et ab. Quidem ex cum dignissimos rerum quisquam nihil veritatis. Consequatur minima accusantium placeat qui laudantium. Iure accusamus possimus dolorem. Et sint fugiat omnis maxime. Et tempore culpa velit sed cumque temporibus totam.	/images/course_example_image.png	approved	\N	52.4	4.57
24c95b55-0d54-473f-8581-2dff794c72c4	8efd743d-fcaa-468c-b3d6-693fc90218df	85	280	Course 80	Omnis eos quaerat repudiandae sapiente ipsam vel itaque. Tenetur veniam ea id ex. Non quos dolore itaque vel nam repellendus debitis. Commodi autem atque doloribus rerum omnis numquam. Saepe et aliquam excepturi. Quis quam quod explicabo autem magni. Esse rem id magni inventore dolores mollitia qui. Magni voluptate dolore id minus. Reiciendis et molestias quibusdam et totam reiciendis dolor. Quo enim ut voluptatum voluptatum repellendus tempore.	/images/course_example_image.png	approved	\N	66.07	3.03
1c5a3a35-4581-4bb4-9b39-a1fd2cf97b19	76c52bbf-3785-401e-8769-4a375242e8f1	85	318	Course 81	Cumque atque id veniam pariatur optio tempore exercitationem. Perspiciatis enim officiis natus et voluptas ea in voluptatum. Cum dignissimos soluta labore molestiae voluptate facilis nihil. Et consequatur atque minus autem voluptates maiores quod. Accusamus veritatis corporis beatae vero laudantium. Vel unde aut ut. In ut rem voluptatem qui quia rerum inventore. Sed ab ea delectus aut voluptatem. Fuga ea ad rem molestias voluptas blanditiis. Natus consequuntur harum velit vitae eos ut.	/images/course_example_image.png	approved	\N	72.55	3.92
a5563359-a1b0-46a1-aaa3-8f234549fad5	0d18a042-53a6-4b8a-af6b-f2fbc317db2c	85	274	Course 82	Atque in labore quo earum sed voluptas vel. Est ut quia ab ea impedit. Quasi reprehenderit non similique nihil. Quae fuga in aspernatur laudantium. Minima quos dignissimos delectus sunt. Eum sed sunt tempore ipsum enim. Dolor voluptatibus pariatur dolores earum voluptatem fugiat officia fugiat. Mollitia nemo qui sit earum. Sint dolores vero pariatur. Explicabo deserunt in quibusdam illum minus dolores optio.	/images/course_example_image.png	approved	\N	98.01	3.45
df56da09-dbbc-480b-a16f-a7d8e386ee57	0018f28d-245a-4c69-89de-280927f40cdb	85	265	Course 83	Asperiores aut maiores non. Nostrum consequatur vel aut est voluptates aut praesentium. Nihil blanditiis provident libero dignissimos animi labore eos. Dolores fugiat esse officiis quia suscipit. Fugit doloribus aperiam minima libero nostrum totam nesciunt beatae. Totam neque possimus sit dolores. Corporis ex quia sequi iste. Ab aliquid recusandae illum explicabo est quod. Esse atque sit molestiae sint. Ut voluptas assumenda alias voluptatem praesentium.	/images/course_example_image.png	approved	\N	56.09	4.27
914e994e-7c0f-45fd-83eb-5c4968a75c98	5d3437ca-1563-41da-8eea-c5780e6c355c	85	290	Course 84	Id magni et ipsam dolor mollitia culpa iusto reiciendis. Dolorem earum quis eius impedit animi consequatur. Incidunt beatae natus consequatur. Alias aut quisquam autem rerum voluptatibus. Veritatis nisi animi optio provident autem necessitatibus. A quia rerum maxime quasi voluptas voluptatem. Sed similique illum libero ipsam. Corrupti molestiae eveniet tenetur. Iure repudiandae accusantium ut corrupti in excepturi sed. Rerum sunt ut nihil magni dolorem provident illum.	/images/course_example_image.png	approved	\N	74.68	3.58
89d755e3-6414-426b-a754-ae36960f2cca	aaac4952-a5f7-4ce7-b3b9-68c23c7f7fd2	85	290	Course 85	Quibusdam qui omnis incidunt odio rerum. Deleniti est veniam quasi amet beatae itaque. Non dolores ducimus ducimus sed aut voluptate. Dolorum voluptas debitis est itaque aut id non. Optio autem provident quibusdam voluptatibus. Aliquid qui sit ab qui libero. Sint enim doloremque non rem ipsum quidem. Animi minima odio magnam. Ad cum similique dolores. Provident sint explicabo recusandae velit molestiae.	/images/course_example_image.png	approved	\N	75.97	3.76
ec2ab57f-202a-4029-8ab1-0cc72ad611ee	d56e0cae-5aa1-4eee-a86e-db0ebbe57e31	85	303	Course 86	Optio eum illum debitis tempore esse consequatur beatae. Numquam iste repellendus magni et quia fugit eaque enim. Est aut et enim natus impedit alias totam maiores. Officiis ut voluptas quo ut. Quam eaque minima quam ipsam. Ut adipisci ex commodi placeat. Unde a reiciendis iste maiores. Architecto voluptatum nobis delectus recusandae nam. Tempora sed blanditiis ut quidem voluptates nihil adipisci. Esse aut temporibus non similique beatae.	/images/course_example_image.png	approved	\N	85.7	3.76
0bdf5acf-332d-4560-99c7-39469a1f293d	feec659e-b1c7-4fcc-b361-8f2b73b08e96	85	292	Course 87	Saepe aperiam sit debitis ut cum. Est repellendus voluptatibus quo ratione a commodi et nihil. Doloremque quia ut non. Voluptates et et similique ipsam ullam eum enim vel. Officiis laborum eum aperiam et iste ratione consequatur. Ab neque esse eaque tenetur optio. Aliquam et doloribus fugit consequatur. Exercitationem distinctio aliquam totam vel vel et excepturi. Dolores placeat dolor autem laborum voluptas enim. Ut hic et voluptates velit.	/images/course_example_image.png	approved	\N	73.36	4.7
1f47f2c9-7192-4a02-9040-9f13f1183d48	ce905ec9-52fa-44e3-ae76-2b54c31750cd	85	267	Course 88	Natus quam excepturi quia. Esse maxime asperiores molestias soluta magnam exercitationem. Ut esse quo aut a dolor. Voluptas in voluptatibus eum quia voluptas occaecati. Iste minus eum provident ut aut ab reiciendis sint. Tenetur asperiores facilis et libero. Facere accusantium est repellat aliquam consequuntur minima quasi. Porro dolor aut ea fugiat tempora esse ut. Iure officiis fuga illo porro. Consectetur laborum aliquid exercitationem omnis dignissimos.	/images/course_example_image.png	approved	\N	65.79	4.61
b107f8b9-1fa5-43a0-8c4c-0578e255cae0	ef87ad36-e9a7-4760-9e72-b79d8518d561	85	319	Course 89	Quo totam soluta autem veritatis at ad qui. Qui occaecati quas excepturi voluptatum. Debitis est ratione in provident hic facilis. Consectetur ut facilis quo itaque ut ducimus iure aut. Et similique neque quo sed. Quis quam sed necessitatibus a. Rem illum ea sed. Iure et asperiores et nihil aut. Soluta aperiam aspernatur omnis ad sed voluptate. Aut dolor ut repellat eum.	/images/course_example_image.png	approved	\N	93.15	4.93
84253cd3-c720-448f-8488-ecb68ee2b9de	8773681b-a255-4227-98bb-0cf5c19cbfb6	85	313	Course 90	Temporibus eos harum mollitia molestias qui. Quos ut qui in culpa perferendis aut sunt. Dicta ab autem assumenda animi in molestiae mollitia quos. Voluptatum qui aut velit voluptas sunt et suscipit voluptatem. Atque accusantium animi placeat cupiditate aut eum explicabo. Ab eos rerum temporibus aliquid nulla aliquid. Iure placeat perspiciatis voluptatibus enim aliquid sint error. Voluptatem quia est omnis occaecati illum. Repellendus iure adipisci ipsam accusamus voluptate inventore iure. Iste dolore est laudantium quis.	/images/course_example_image.png	approved	\N	72.05	3.07
bda7e996-09bd-48cf-9f43-05c44527164d	4e8ceb76-fe35-44f2-a82f-e205aec183c7	85	289	Course 91	Soluta et aut unde corrupti. Qui explicabo laborum tempora placeat quae eaque qui. Aliquid placeat atque inventore est beatae at. Unde ipsam nihil dolorem. Commodi veniam velit temporibus rerum. Est sunt necessitatibus totam quis sit sit doloremque. Qui aliquam ipsa et numquam molestias debitis expedita. Omnis ut a amet unde id animi exercitationem cumque. Nostrum a in ea voluptas quo tempore. Sunt ea qui totam ea tempore.	/images/course_example_image.png	approved	\N	97.44	4.54
013fbdc2-6959-466d-ba2a-484cde6b7a56	249a333a-041a-464c-a858-d796e0fc7716	85	309	Course 92	Voluptatem quis et sunt possimus. Aut cum quibusdam blanditiis eius quia. Blanditiis possimus similique qui qui soluta mollitia. Autem qui reiciendis et aliquid facilis cumque. Sequi quis quibusdam et quae vel. Eos quia voluptatibus accusantium recusandae eos. Et aut aut non id consequatur. Totam ut ex doloribus aut dolorem. Explicabo et et ducimus nesciunt cupiditate architecto sed. Autem possimus alias aut nisi nemo.	/images/course_example_image.png	approved	\N	72.11	3.23
480b687a-d17c-4ff7-964c-7bc1b5222918	199b5d5e-1639-4302-8ee2-869f6589ef83	85	304	Course 93	Sequi voluptatem sequi laborum eligendi. Consectetur impedit repellendus voluptate repellat maiores. Eaque atque id minus laudantium sint repellat sint. Maiores dolor non minus iusto. Expedita omnis inventore dolor commodi. Similique nostrum qui minima aspernatur dicta. Et consequatur et in aut nihil. Est recusandae distinctio facere corporis tempora inventore. Dolor in sequi cum et voluptatem facilis. Voluptatem quo sed corporis mollitia fugit.	/images/course_example_image.png	approved	\N	53.82	4.6
255de658-c216-48b4-9bfd-f4d4f078cda9	0df8a323-01fc-4f5a-b92c-ceaf6119003e	85	268	Course 94	Aut et aut quia ratione officia voluptatum fugiat. Est qui corrupti consequatur. Tempore rerum numquam excepturi optio nobis porro qui tempore. Mollitia voluptas illum voluptas eius voluptatem. Aut distinctio ratione magni aliquid quia dolore. Cumque perferendis ullam eum dolor dolores ut commodi. Quia consequatur dignissimos delectus dolor nihil neque. Quo sequi perferendis aut ad vel. Tempora est rem voluptatibus dolorem nemo enim fugit. Pariatur et accusamus ducimus incidunt corrupti facilis officia.	/images/course_example_image.png	approved	\N	69.75	4.26
991619ba-0002-4582-9813-1c73ecba3228	dedcdcd9-6dd3-4d54-88bb-1db22991e19c	85	289	Course 95	Id dignissimos assumenda incidunt ea. Neque architecto voluptatem iste incidunt. Neque sit sequi et et temporibus fugit quisquam. Tempora quia unde fugiat tempore. Ex veritatis sapiente qui cum quis. Cum voluptas sed nobis eaque ex. Rerum vel ad quos magni ipsa. Earum dignissimos quo consectetur nihil sed voluptas. Beatae quis id sed quos facilis sint mollitia. Dolores dolores illo nostrum recusandae nihil natus molestias.	/images/course_example_image.png	approved	\N	54.13	3.81
f6b05cbc-0430-4654-a3ea-646f9fefdcae	814f4998-09a1-4752-9095-df4c1a3718a6	85	300	Course 96	Nihil tempora repudiandae omnis tempora illum accusamus. Fuga molestias est exercitationem voluptas. Praesentium id id consequatur dolorum et. Aut inventore officiis laboriosam tempora ab. Dicta est omnis ea alias. Rem commodi dolore laboriosam ea explicabo temporibus velit. Omnis facere est nihil. Perferendis vel explicabo qui nostrum. Quo est excepturi natus non est. Laudantium aliquam animi eveniet voluptas deleniti.	/images/course_example_image.png	approved	\N	87.83	3.4
f6452b49-a4ca-4d0c-a1a7-e0884fa2e118	73f45241-2f28-4b1c-879c-46ecc6ec9055	85	298	Course 97	Laudantium unde provident eum voluptate esse. Sint suscipit non commodi voluptate architecto. Id error autem et molestiae deserunt aut omnis. Nemo in maiores ipsa voluptate laborum. Sapiente odit soluta ut fugit. Quo quos sed autem excepturi incidunt sit. Voluptatem cum dolores et modi officia minima qui. Similique saepe dolor numquam maiores optio. Et ipsum omnis et et libero. Labore sunt in quia consequatur rerum.	/images/course_example_image.png	approved	\N	60.35	3.86
d2cb899c-580c-4334-9bf4-7e7f802ad613	138fd8e5-81b6-4fa1-888d-0e792fbc2827	85	305	Course 98	Repellendus veniam nulla illum id quia laudantium assumenda. Perspiciatis sunt dicta in alias minima quo est vero. Ut expedita in provident consequatur cumque est. Sint non corrupti assumenda voluptatem est. Aliquid autem enim non corrupti dolore quo beatae. Et vel rerum velit animi. Explicabo fugiat alias voluptatem vero qui illo. Similique enim voluptas beatae veniam aut ex voluptates quia. Ea sed beatae dignissimos fugiat quae magni. Non et molestias qui omnis.	/images/course_example_image.png	approved	\N	80.01	4.41
34752141-dac3-436f-9b2a-20ad263681da	8bfbcabd-027d-476c-a38d-7400a924663f	85	297	Course 99	Rem sed ipsam quia sit et amet nobis. Quo est nihil laboriosam quia ea. Necessitatibus at neque vero ducimus sunt dolorem ipsam. Porro excepturi inventore voluptatem illum dolores aut qui ut. Ad quos vel aut quam alias voluptas. Qui placeat est suscipit. Molestias mollitia omnis omnis non. Iste omnis aliquid saepe quos. Ea quis sit nam amet pariatur enim magnam. Vitae fugit minima amet sit.	/images/course_example_image.png	approved	\N	80.73	3.06
159aa83f-7b6f-4c00-8b2d-89926c89ab5f	b5f9811e-96e4-4af6-9189-89413afbebc6	85	300	Course 100	In dolores voluptatem facere. Amet illum in omnis aut aut architecto deserunt. Dolore provident veniam ab quas nam eum provident. Nulla corporis debitis quae inventore corporis quasi cupiditate. Reiciendis unde consectetur inventore quidem. In ea mollitia sunt in. Doloribus eos sit itaque neque. Molestias repudiandae voluptatum consectetur unde. Perferendis aspernatur libero cum architecto nisi amet culpa. Vitae quo dolore accusamus.	/images/course_example_image.png	approved	\N	63.25	4.5
\.


--
-- TOC entry 4939 (class 0 OID 16699)
-- Dependencies: 231
-- Data for Name: course_draft; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_draft (id, category_id, name, description, image_path, status, public_image_id, price) FROM stdin;
ab7fda69-cc50-4f88-893f-d0d6856cd41f	263	Course 1	Non dolor et repellendus quo vel officia assumenda. Amet ullam ducimus beatae totam. Repellendus dolore eos ullam modi placeat. Quas adipisci aut omnis quibusdam. Rerum facilis voluptatum expedita qui omnis. Dolorem nihil dolorem ducimus fugiat eaque est. Corporis qui at recusandae ab. Amet ea natus sapiente ex. Perspiciatis recusandae aspernatur aut atque expedita rerum in sunt. Autem non fuga recusandae sed dolores est quia.	/images/course_example_image.png	approved	\N	72.24
58f1d5db-23ea-40ca-847e-420cb60073ca	287	Course 2	Tempore iure error doloribus sit sint. Sed et dignissimos ut minus. Ut quaerat doloremque et sit molestias eos dolorem. Autem distinctio et reiciendis. Deserunt ab ab sunt necessitatibus. Voluptatem est sunt qui. Consectetur voluptatem perspiciatis doloribus. Ab veniam aut possimus maiores quam necessitatibus a. Quae totam quod libero suscipit dolorem odit blanditiis amet. Consectetur quos et cupiditate animi possimus.	/images/course_example_image.png	approved	\N	54.07
06bc9988-d285-40fa-94eb-87ef36d54e8c	309	Course 3	Et eligendi ut quo quas. Ipsum quaerat nobis rerum ducimus ut unde. Vel et quis vel in. A occaecati eum assumenda. Rem iure est reiciendis quia voluptatem architecto velit repellendus. Cupiditate ratione quam officiis exercitationem autem at. Labore at exercitationem dolorum. Est illum non quibusdam sint rem. Nobis qui sit consequatur reiciendis. Voluptatibus distinctio eum et laboriosam.	/images/course_example_image.png	approved	\N	88.69
ac622ebd-9a5a-4232-a91f-c8e4294b2b77	293	Course 4	Corrupti natus ea quidem quia eveniet corrupti necessitatibus quos. Voluptatem quia ea ut ab omnis praesentium. Beatae corrupti expedita aut minima dolorum. Laudantium magni sit blanditiis numquam. Quia quas neque nesciunt dolore quo qui voluptate incidunt. Provident cupiditate fuga temporibus sit temporibus. Et illo dolorem in ex. Cupiditate omnis nesciunt est iure eius dolores ut. Inventore est atque est dolor ut. Deleniti omnis velit et vel.	/images/course_example_image.png	approved	\N	56.9
cce759cc-f400-46d9-9576-db7719aec877	300	Course 5	Est facere optio aspernatur consequuntur et dolor sapiente. Sint dolore nisi eaque officia voluptatem velit voluptas. Architecto maiores fugit est qui. Quia ut deserunt provident nesciunt corrupti unde. Sit expedita doloremque nulla sequi. Quia ipsum quidem quaerat repellat eos molestiae. Totam hic quidem qui quasi itaque voluptatem. Ducimus a alias quia aut pariatur inventore eum. Aperiam aut eum et a tenetur et qui. Aspernatur praesentium perferendis modi quaerat illum nesciunt ut eos.	/images/course_example_image.png	approved	\N	61.34
5132c01c-b5ed-4660-a743-8998ca3009e6	268	Course 6	Quis ducimus voluptatem omnis. Et molestias quam recusandae debitis nihil. Magni minus alias aut aperiam odio iste eum. Corporis ut dolorem sint est libero autem illo. Iste est mollitia aut quia dolores. Rerum tempore error ducimus magnam. Omnis ipsa tempore labore accusamus. Molestiae non nesciunt minus aut voluptatum explicabo voluptate. Ex facilis aut consequatur. Et iste suscipit consequatur ut perspiciatis enim dolor.	/images/course_example_image.png	approved	\N	97.65
6e90f087-4ba8-4c21-bea5-7d02851e6af2	325	Course 7	Reiciendis repellat porro omnis voluptatem molestiae vitae accusantium. Nesciunt consequuntur ad molestiae quibusdam quae. Sed in minima enim provident esse necessitatibus. Aut perferendis magnam ratione doloremque labore. Dolorem animi sed est ab id. Tempora ut sit debitis quia illum. Nam et similique reiciendis fugit non voluptas. Quia ad recusandae est recusandae consequatur asperiores. Deleniti doloremque nulla voluptatum cumque in blanditiis dolores explicabo. Qui tenetur minus quaerat repellat saepe sit.	/images/course_example_image.png	approved	\N	71.65
57ffbb64-70c6-4ad6-9f06-eafea2349fab	313	Course 8	Vel dolorem non debitis perferendis eos modi ratione et. Quia odit fugiat nisi reprehenderit. Provident voluptatum sint quisquam perferendis qui dolorem voluptatem. Atque saepe dolorum quisquam nulla maxime eos. Tempore at ea deleniti occaecati non molestiae. Numquam eum quidem sit maiores tempore quia accusamus. Aliquid est aut ut harum excepturi. Iste qui blanditiis id aut quibusdam sint atque maxime. Et corporis laborum voluptatem quae. Sint consequuntur animi rerum debitis quasi molestias quisquam.	/images/course_example_image.png	approved	\N	52.01
fd3913db-13f3-46d4-bf7e-5853d2f173da	322	Course 9	Maxime laboriosam distinctio velit omnis exercitationem nostrum. Dolorem rem voluptas quam laborum deleniti voluptatem. Eum alias veniam quidem quas. Et quis vel non quis vel. Aut voluptas est molestias inventore earum earum placeat nesciunt. Illum doloremque optio non maiores qui. Repudiandae suscipit molestiae eum aliquid quisquam rem perferendis enim. At est quos nihil sint. Distinctio blanditiis amet corporis minima laborum. Magnam quos quia ea ducimus dolores.	/images/course_example_image.png	approved	\N	95.44
6bf1c2e3-0544-4edc-9a6f-5998d619a3fc	287	Course 10	Praesentium earum et praesentium. Tempore libero deserunt nesciunt voluptas. Fugit doloremque alias aperiam quibusdam. Nihil veritatis commodi et labore non consequatur amet. Ab maxime voluptas non corrupti. Qui qui vero autem voluptatem. Aut labore minima quis vel quia ut. Inventore qui aut hic id voluptates ipsa. Consequuntur exercitationem excepturi qui distinctio. Consequatur est nostrum alias porro dolorum iusto.	/images/course_example_image.png	approved	\N	73.04
3a266a53-739e-44d8-ad15-2804e09e4107	265	Course 11	Omnis quia rerum est ipsam est. Earum et vero sequi sed accusantium iste facilis. Labore eum vel quos rem blanditiis excepturi saepe. Quos dolores quo commodi omnis laboriosam doloribus. Nihil adipisci iste at error. Harum praesentium odit ad sint sapiente consequatur. Quisquam laudantium animi aperiam. Voluptate quo saepe repudiandae quo et illo. Voluptatem rerum dolore id et omnis. Asperiores exercitationem molestiae et voluptatibus excepturi vero molestiae.	/images/course_example_image.png	approved	\N	54.92
fafb327b-6f56-45d6-9ea4-43ce6dcb4e5c	277	Course 12	Est natus excepturi temporibus fuga ut vel. Et modi qui commodi magnam. Perferendis fugiat voluptas qui voluptatibus similique aliquid aut. Laboriosam consectetur laborum dolorum expedita et. Dolorum quis earum nam veniam non quibusdam vero. Consequuntur voluptate veritatis id reprehenderit hic aut. Quia perspiciatis deserunt voluptas in. Laudantium ad fugit aut quae minus. Voluptate alias repellat magnam dolorum corrupti quos laudantium. Alias qui qui ea laborum accusamus magnam nulla dolores.	/images/course_example_image.png	approved	\N	95.41
da5dbf21-65b4-4860-9402-4cd927cca99d	325	Course 13	Sit non et vero iure at nostrum. Alias nam nihil cupiditate deleniti ipsum velit et. Deleniti ut voluptas quasi. Et quod voluptas maxime voluptatibus. Aperiam dignissimos officia quo est. Ipsum doloremque ipsa voluptatem qui omnis ut ut. Enim id sed corrupti fugit pariatur. Omnis quam veniam tenetur delectus necessitatibus sunt accusamus quia. Animi possimus iusto culpa asperiores. Velit enim est accusamus doloremque et.	/images/course_example_image.png	approved	\N	97.78
3f5645ea-2b83-47c6-a8b1-f5d0b31c94e0	282	Course 14	Accusantium at voluptatem odio laudantium. Autem sed vel sequi at molestiae. Dolor quo quas ex qui delectus aut. Cum voluptatibus quo repellendus. Qui odio sint aut enim ipsa. Eveniet dolore vel velit. Distinctio autem et animi beatae odio voluptas. Error facere est quis ut. Et dolorem magnam ex magnam voluptatem delectus quis. Doloremque nihil exercitationem dicta numquam.	/images/course_example_image.png	approved	\N	67.43
4b02dc17-b042-4c39-aa6e-4526693adf25	309	Course 15	Aperiam laudantium voluptates est enim ut. Assumenda maxime iure amet. Sit quia ad repudiandae. Aut sapiente iure unde eveniet dolores et. Nostrum quod iste ea enim sequi. Et at non provident qui. Dolor id consequatur rerum consequatur unde. Nihil debitis quibusdam debitis nobis commodi est. Sed aut doloribus et sed. Ex perspiciatis est aut.	/images/course_example_image.png	approved	\N	90.07
00d7509a-4449-403e-b840-65ba577e6451	298	Course 16	Adipisci quibusdam accusamus ducimus qui dolorum. Illo voluptatem expedita sed praesentium autem animi. Nostrum ipsum possimus dolore perspiciatis. Recusandae voluptatem asperiores quia a labore. Dolor ea quia sint. Tempora autem aut omnis qui deserunt qui. Debitis quia voluptatem corporis nemo laboriosam animi rem. Cupiditate repellendus doloribus officia repellat sunt quidem occaecati suscipit. Numquam enim eligendi aut minima a ratione. Officiis ut et deserunt ipsam.	/images/course_example_image.png	approved	\N	87.33
b40667ba-2bde-4c3c-8150-588c9f90e826	289	Course 17	Aliquam ab consequatur totam asperiores sint nemo consequatur architecto. Est aut laboriosam qui. Fugit dignissimos tempora enim consectetur veritatis id. Harum odio commodi deserunt voluptatum. Nemo reiciendis molestiae est. Hic blanditiis eveniet sint quo. Velit quis voluptas maiores rem culpa est et. Labore dolores labore deleniti est ipsum quia tempora. Consequuntur commodi rerum suscipit cupiditate soluta aspernatur necessitatibus. Sapiente nesciunt et qui quasi voluptatem et quo.	/images/course_example_image.png	approved	\N	60.8
27479711-c932-415f-bfa7-3a2e7d01535d	308	Course 18	Aperiam nam dolor assumenda sit architecto explicabo aliquid. Cum id aut consectetur adipisci. Omnis in ipsam ut iure maxime corrupti. Sequi quaerat non et dolorem qui sed sit. Sunt aliquid voluptas architecto labore. Ratione pariatur culpa dolore aut sunt voluptas ipsam dolorem. Necessitatibus cum eum velit non ut provident laborum a. Autem ipsa quibusdam ut est. Modi et autem a non accusantium esse. Sit vero magni voluptatem facere nam error.	/images/course_example_image.png	approved	\N	51.6
436f3ccf-3a28-4473-b4ea-a18ac740144e	298	Course 19	Quam suscipit sed distinctio nobis commodi unde voluptate alias. Labore voluptatem nisi officiis quos eligendi. Vel earum ut provident hic. Omnis et maiores quasi autem. Et neque quidem alias eius modi. Inventore doloribus maiores velit et. Necessitatibus ut eligendi autem facilis magnam. Doloribus occaecati placeat et vitae. Est est repellat qui repellat reprehenderit ea. Reiciendis dolor impedit a tempora non dicta dolorem.	/images/course_example_image.png	approved	\N	67.48
c21aa487-4469-4cf8-aa88-d7b250380603	320	Course 20	Magni ex ducimus harum enim similique perspiciatis. Excepturi voluptatem consectetur et nihil voluptatem. Ex officiis enim qui beatae. Minus aliquam quae dolor dicta eum recusandae beatae. Consequuntur debitis ea commodi accusantium. Quos vel neque consequatur enim tempora. Aliquam qui maxime quidem odit. Tempora et omnis dolorem aut sunt. Et omnis ullam aut est. Quidem ducimus soluta aut iste.	/images/course_example_image.png	approved	\N	68.94
5ab8314a-e8c8-4d64-9c16-9c7f4ed58b0f	283	Course 21	Voluptate officia iusto voluptas architecto nostrum rem. Et et molestiae ex et non et culpa. Natus ut saepe sed deserunt dolorem placeat. Debitis culpa quia sit velit. Voluptas dolorem consequatur adipisci numquam. Ratione at ut est ex nulla excepturi omnis. Nisi sed similique ut commodi et. Vel non quia incidunt sit ullam labore. Molestias totam unde culpa odio non labore reiciendis. Aspernatur alias atque possimus fugiat.	/images/course_example_image.png	approved	\N	71.96
fe4e594d-c634-4cb1-81e3-5fa7bafd421a	279	Course 22	Ex architecto molestiae at cupiditate aut voluptatem. Laboriosam sed laboriosam provident ex tempore ut eveniet. Est accusantium amet sit. Asperiores et ullam pariatur sapiente error temporibus. Facilis aspernatur est qui error a voluptates. Eos exercitationem cupiditate odio consequuntur tempore ipsa ad. Architecto sit similique earum pariatur cupiditate ex quos. Dolorum corporis accusamus corrupti quibusdam. Cupiditate nesciunt pariatur repellat accusamus illo magni. Numquam possimus molestiae qui ut odio libero modi.	/images/course_example_image.png	approved	\N	54.16
cd082611-9376-4fb3-9585-3e89f5fce16c	289	Course 23	Eius ipsam quis libero ex quis quibusdam rerum. Soluta facilis quidem repudiandae quas est ea et sunt. A perspiciatis pariatur harum in omnis cum deleniti. Laudantium ratione et et dolorem. Rerum molestiae fugiat non. Sint aut et corrupti enim est voluptatem consequatur. Fuga possimus tempore doloribus esse assumenda quis praesentium quasi. Maiores consequatur vero autem cumque sequi illo voluptatem. Enim sit alias fuga voluptates odio aut dolores qui. Unde deserunt dolor debitis.	/images/course_example_image.png	approved	\N	55.76
527c93c2-ff56-4c0f-9a38-2198aa697d49	264	Course 24	Provident sint molestias pariatur qui ipsa est officia minima. Commodi quis perferendis inventore accusamus. Nostrum minus est rem vel voluptate qui dicta eius. Sit sunt laudantium aperiam natus voluptatem id veniam. Explicabo et voluptatem veniam delectus magnam perferendis quis. Voluptatem voluptas corporis ea fugiat quae non magnam. Quo aut nihil ut eligendi sit at praesentium. Enim at saepe nesciunt sint ut possimus doloremque fugit. Quos sed sunt animi corporis. Ut necessitatibus maxime sit et pariatur suscipit et.	/images/course_example_image.png	approved	\N	54.21
5966bf52-d026-4fb4-8d6a-0b99c02d8144	287	Course 25	Ut saepe deleniti consequuntur. Sunt quis assumenda accusantium at eligendi. Quidem et est rerum fuga libero. Autem reiciendis culpa recusandae. Molestiae voluptates consequuntur officia quaerat qui cupiditate. Omnis mollitia nulla commodi. Voluptatem quasi dolor dolorem voluptatem in. Occaecati eum occaecati sed qui. Debitis cupiditate sunt praesentium aut assumenda nisi perspiciatis atque. Adipisci quia voluptatibus dignissimos aut ea.	/images/course_example_image.png	approved	\N	79.9
7a26f752-850e-4def-b08f-8e391d5a51c4	297	Course 26	Praesentium amet eveniet minus voluptates. Temporibus commodi est iure aut voluptates. Quos perferendis molestiae in inventore placeat. Animi porro atque perferendis rerum et. Rerum maiores voluptatem harum deleniti sunt eum. In eius non quia eos sequi. Consequatur ut sed exercitationem sunt. Ipsa architecto id modi provident. Qui possimus repellendus minima. Qui deserunt eveniet qui officia.	/images/course_example_image.png	approved	\N	82.06
756599b6-343e-43d8-880b-ca9fa56efc94	280	Course 27	Cupiditate sed sit rerum nemo voluptas. Iste consequatur ut ut voluptatum. Mollitia alias fuga eum nisi laboriosam. Accusamus velit illo eveniet occaecati commodi. Est rem sit repudiandae possimus. Cupiditate impedit corrupti temporibus ipsa sapiente quos commodi. Deserunt recusandae in eligendi ullam. Ea a qui reiciendis quo rerum quasi enim. Magni voluptates voluptas cumque illo voluptatibus magnam sed. Praesentium nihil labore voluptatem.	/images/course_example_image.png	approved	\N	91.87
7af90bc1-a89c-42ea-9d25-61312b0bfc80	324	Course 28	Dolor ipsa distinctio sit non sint et. Quam qui pariatur placeat voluptatem qui. Magni at facilis autem dolores saepe quas. Corrupti dolorem accusamus ipsa laudantium. Deleniti necessitatibus ut corrupti eos molestiae. Quasi cum accusantium aut placeat iste ea et perspiciatis. Rem nihil fuga autem in rem iusto. Sunt asperiores at esse est. Omnis voluptatem quod repudiandae dolorem. Atque dolore voluptatibus quia vel.	/images/course_example_image.png	approved	\N	91.67
1b527bae-1776-4e97-811a-e6ee0ac9b856	292	Course 29	Quibusdam deserunt perferendis molestiae accusamus. Molestias non quos reiciendis quisquam mollitia. Aliquam dolor adipisci temporibus nobis ullam eos odit rerum. Sint ducimus reiciendis consequatur pariatur sed. Voluptas amet magni est velit repudiandae officiis laudantium qui. Repellat sint ipsa id quia delectus. Ut aut ipsum nostrum nesciunt est. Velit accusamus reprehenderit porro qui voluptas animi ullam. Voluptas voluptatum enim molestiae distinctio ut totam. Ullam voluptatem esse vero quam quo eligendi explicabo.	/images/course_example_image.png	approved	\N	98.31
b462562b-2f98-4f26-bec1-1b8eb04bd14e	274	Course 30	Inventore quia enim itaque iure. Repellat velit maiores aut harum dolor dolores aut. Voluptate qui ut labore culpa ea non. A ducimus temporibus explicabo. Nihil deserunt ea illum ipsum veritatis est numquam. Iste nisi dolores et fuga omnis quos aliquid sapiente. Placeat voluptate qui magni aut quibusdam. Dolore nihil voluptate atque non. Magni iste porro explicabo quo. Nam officia culpa dolor est enim vero doloremque.	/images/course_example_image.png	approved	\N	83.01
2002c367-7681-4ff6-9d7a-aeb9f372848d	305	Course 31	Dolorum placeat recusandae quaerat quis. In alias distinctio fugiat tenetur. Aut inventore nesciunt et consequatur inventore aut. Earum omnis iste iste ut qui. Ratione et laboriosam iste in illum expedita. Ut animi eos tempore laborum perspiciatis eum accusantium. Aliquid sit voluptatem et ut aut. Dolore aut culpa quas nam ut cupiditate minima. Quas architecto hic ut et illo aut et. Libero dolores illo quia sint beatae sed quis sed.	/images/course_example_image.png	approved	\N	54.79
08344e18-07fd-48b1-9ed0-859cea43b0c1	269	Course 32	Nobis totam dolores eum et vero sapiente. Sequi sit nisi dolorum quo ipsa eos quo. Minus eum consectetur quo aspernatur consequatur cum. Dolorem earum est nam fugit. Sint quo nesciunt sed inventore officiis. Porro ut similique earum accusantium voluptates. Porro rem modi et iste quo. Molestiae minima amet sit corporis. Natus eum ratione a vero qui qui eos. Veritatis voluptate distinctio vitae dolorum voluptatibus totam ratione.	/images/course_example_image.png	approved	\N	92.19
0f26c98c-376d-49de-9633-7fe4899f67f8	320	Course 33	In animi eum ipsum minus ut laborum. Nulla et molestias error dolor. Atque laborum iste voluptas dolorum. Iusto aut nostrum doloribus tempore aut dignissimos error culpa. Libero aut deserunt reprehenderit nisi. Qui voluptatibus alias dolor ut ut. Quis reiciendis quos aliquid commodi. Porro qui sint qui perspiciatis omnis recusandae cum facilis. Ullam est et mollitia earum. Nesciunt ipsam asperiores et id in saepe officiis.	/images/course_example_image.png	approved	\N	67.26
8f41dec1-420c-44f5-ab60-f5e35d921efb	304	Course 34	Sapiente veritatis natus quidem dolores modi. Reiciendis voluptatem possimus atque cupiditate. Recusandae quis exercitationem est non quis. Quos omnis dolores assumenda recusandae harum delectus commodi possimus. Quis ullam dicta consequatur inventore adipisci qui. Ut eveniet qui accusantium voluptatem voluptatem quam. Animi perspiciatis non aperiam sed qui ea quia. In sed facere nisi quaerat. Vel blanditiis et in magnam repellendus. Beatae veritatis dicta esse nostrum dolorem porro ratione.	/images/course_example_image.png	approved	\N	74.56
c1bd639a-ebd9-4af1-82b8-b28797a22aac	318	Course 35	Enim facere est et ipsam voluptas aliquam ut. Ullam ipsam nihil dolorem voluptas esse eaque aut. Non nam dolorem ut ipsam optio similique et magnam. Occaecati amet exercitationem non vitae quae inventore. At est praesentium ea qui voluptate. Eligendi quod rem ut itaque provident et sunt. Voluptas possimus voluptates harum sint velit tenetur. Quasi voluptas ipsa est velit. Tenetur vitae id velit sint et perspiciatis nobis. Voluptas quidem consequuntur eligendi reprehenderit non rerum optio error.	/images/course_example_image.png	approved	\N	61.47
ee917493-50c9-4f94-bd87-f416bf21593d	275	Course 36	Sunt qui et corporis dicta aut ea quaerat. Voluptatem fugit et excepturi dolores voluptas. Velit provident rerum vel possimus unde. Perspiciatis explicabo enim aliquam ut ut possimus repudiandae. Laudantium officiis eos nesciunt et doloribus fugit. Nemo officiis explicabo qui nobis. Ut est repellendus eaque nemo facere et quisquam labore. Voluptatem iusto quis similique beatae vel. Iste asperiores architecto qui consequatur. Nam nihil ut rerum ipsa.	/images/course_example_image.png	approved	\N	90.52
073756d8-3eff-4831-a1ae-4323f1d2aea8	275	Course 37	Ea iure ad dicta reiciendis error. Explicabo eius et non rem. Dolorum ea asperiores reiciendis perspiciatis veritatis. Qui adipisci iure nemo ut qui eius. Facere officiis non deleniti maiores. Modi doloribus perspiciatis repellat. Minima voluptas est veritatis ullam. Magnam asperiores autem quia error sunt vero. Fuga et non cumque perspiciatis asperiores quaerat. Unde at dicta et beatae eius.	/images/course_example_image.png	approved	\N	58.53
ee972a66-db08-4fe5-bf26-b607701a9d7a	315	Course 38	Est nemo explicabo quia vel voluptatem. Ut laborum qui sint impedit id excepturi ad. Vel ad libero nulla laborum. Culpa magnam dolorum nostrum qui libero quia. Veritatis quibusdam et exercitationem. Veniam molestias earum perspiciatis quam vero ducimus. Minima quo deserunt cupiditate. Minus optio animi enim dignissimos voluptatem eligendi. Id non sed itaque et voluptatibus iure. Aliquid nobis animi aliquam laboriosam nisi voluptatem voluptas.	/images/course_example_image.png	approved	\N	92.06
d15c3de1-b9e4-4e27-84c1-60a540dcbe40	295	Course 39	Ex nisi sit autem consequuntur molestiae sunt voluptatibus. Quidem commodi explicabo voluptates qui. Rerum cum eos dolore consequatur id. Dolor voluptatem fugit dolor. Excepturi nam occaecati aut cupiditate voluptates vitae temporibus. Quo culpa voluptatem nesciunt nihil nesciunt sed et. Iure et praesentium aperiam in. Quia exercitationem atque facere repellendus rem. Dolorem eligendi aut tempora repellendus consequatur. Dignissimos sit dignissimos ipsam.	/images/course_example_image.png	approved	\N	75.43
4de728ef-3d78-4551-a568-2066c8285c96	287	Course 40	Optio porro sunt tempora. Soluta sit corporis et voluptas. Voluptas perferendis non architecto omnis et et. At similique dolorum quos iure pariatur minus itaque. Dicta qui rerum aut cumque dignissimos illum. Architecto optio vitae voluptas unde voluptate excepturi numquam. Ut rerum assumenda error animi. Dolor consectetur ipsum eum consectetur sed. Illo saepe cum expedita. Iusto consequatur qui quis laborum nesciunt delectus quia.	/images/course_example_image.png	approved	\N	52.73
bd8fbf79-2de0-40cc-8aa1-d75a75163919	313	Course 41	Voluptas architecto totam error iusto. Sunt neque debitis quos architecto non ut non. Nostrum dolores nobis voluptatem accusamus cum. Modi vero eum assumenda ad et vitae in. Exercitationem eligendi animi facere qui neque quis sit. Ut voluptas ex et rerum ut itaque eius. Laudantium natus modi laudantium exercitationem aut eveniet minima. Ullam enim cupiditate ea rerum. Doloribus doloribus eaque amet. Eum maiores sed molestiae.	/images/course_example_image.png	approved	\N	93.53
e17d877e-f91b-4d36-84cf-32a64ec7c629	293	Course 42	Cumque eligendi aut voluptatem sint quis. Facilis temporibus asperiores iste dicta et dolorem. Error et ipsum accusantium rem quibusdam animi. Eum aut facilis magnam aliquid nihil vitae nesciunt. Est illum nemo rerum corrupti officia provident magni consequuntur. Suscipit quidem veniam et autem modi consequatur. Eligendi sunt ea consequatur. Omnis est in quo sed. Quia voluptatem minima est odit quos qui. Expedita aut iusto aut itaque facilis nostrum consequatur.	/images/course_example_image.png	approved	\N	91.26
12d5a16e-acf3-406c-ae67-94548005162b	323	Course 43	Illum sequi minus dolor impedit repudiandae cum qui. Odio tempora ipsum dolorem quisquam. Necessitatibus labore labore beatae quam quia. Qui ducimus optio quis natus id. Atque sit nostrum officiis repudiandae. Eius dolor voluptatem ex dolor autem ea. Adipisci ratione quaerat animi. Consectetur aliquam voluptatem inventore neque. Consequatur autem magni ducimus fuga eos blanditiis. Aut asperiores dolores fugiat.	/images/course_example_image.png	approved	\N	98.87
882dbe79-7285-42e6-bd84-ec4826060010	279	Course 44	Numquam magnam neque accusantium dolores. Voluptatum hic voluptatem beatae laborum optio praesentium. Beatae deserunt recusandae qui molestiae cupiditate. Reiciendis labore harum ut id fugit. Et a sunt eaque facere ullam in. Pariatur aut praesentium nihil laboriosam. Nobis incidunt quidem iusto omnis in delectus doloribus excepturi. Cum et amet officia modi sed ipsam ut laborum. Autem iste at itaque cupiditate labore ut. Alias autem cum ut impedit earum.	/images/course_example_image.png	approved	\N	72.57
429218cb-6972-43f2-add7-8029d17119ab	307	Course 45	Beatae aliquid qui id ipsa laudantium minima ut qui. Error in rerum recusandae voluptatem. Consequatur quasi quis quae provident. Et itaque aut hic eaque est et est. Id necessitatibus quod et aperiam consequatur laudantium modi. Cum aperiam quos aliquid est quasi mollitia explicabo. Aut aut ut aperiam voluptatum. Odit illum quos nihil expedita. Quos odio deserunt et et et id nihil. Dolor sint id est perferendis delectus.	/images/course_example_image.png	approved	\N	71.42
c28f47fb-efdf-41f4-9625-04755f3aceab	289	Course 46	Atque eveniet omnis et qui est omnis voluptate dolores. Consequatur eos expedita molestiae sapiente sit sunt. Ipsum totam ducimus voluptas sit qui. Ut illum aut molestiae. Est deleniti sint unde impedit quae possimus. Consectetur ipsa asperiores ipsam maiores excepturi necessitatibus. Architecto voluptas ab et rerum quo. Numquam asperiores qui sint aliquid consequatur suscipit est. Temporibus qui nesciunt non laudantium repudiandae. Cumque tempore laborum dolores alias et illo laborum vel.	/images/course_example_image.png	approved	\N	72.86
c3e158df-9779-4e7e-9ac5-6b2c607b741b	292	Course 47	Enim saepe repellat aspernatur quia similique. Et rerum ut vitae doloribus accusantium tenetur. Ut corporis quia dolores iste sit. Velit nobis adipisci qui qui optio doloribus vel. Qui est veritatis ipsa ut vel blanditiis illum. Incidunt aperiam laudantium repellat mollitia. Fugit asperiores voluptatem sit fugiat alias est maiores consequatur. Dolorum quae dolor autem perferendis est incidunt magni. Qui aut voluptatum dolores dolor possimus enim quia rerum. Culpa voluptatum doloremque iste laudantium possimus sed.	/images/course_example_image.png	approved	\N	61.52
7b633950-129b-4cb7-8a31-0f52114793ab	325	Course 48	Esse modi ad eum sit quaerat odio facere. Impedit doloremque eos adipisci sint quia aspernatur. Aut animi et voluptates dolor. Omnis et dolores perspiciatis et nisi sint dolorem incidunt. Ratione voluptates dolore fuga perspiciatis rerum. Quis animi aperiam praesentium illo consectetur. Et dolores non itaque. Est in enim quidem quo vel culpa sed. Culpa in iusto voluptatem at. Est iste velit qui illo alias.	/images/course_example_image.png	approved	\N	74.51
f3d647d4-1002-4358-9a7a-fcf1c3691b39	265	Course 49	Nihil molestiae voluptatem corporis autem eligendi officiis. Debitis libero et at rerum sit inventore ipsam ut. Recusandae et vitae qui est. Aspernatur libero quia veritatis iusto exercitationem sint. Necessitatibus quam ex minima ut odit non culpa earum. Fugiat veritatis numquam veniam rerum est. Repudiandae dignissimos voluptatem deserunt rem cupiditate. Atque qui est earum nihil dolores ducimus numquam. Est dolorem veniam natus porro laboriosam ipsum. Numquam error aut quia est praesentium non fugit.	/images/course_example_image.png	approved	\N	79.64
3387ba2b-24e8-47e5-bd7e-cbe61c6136ad	275	Course 50	Est eum ipsam impedit animi iure odio. Similique non beatae et tempore et voluptatibus et delectus. Sed tempore iste ut reprehenderit. Sed hic necessitatibus minus nulla occaecati. Consectetur qui ducimus maiores sint. Magni distinctio soluta et quis. Ut harum aut a nihil explicabo qui. Distinctio qui libero reprehenderit quibusdam ab. Dolorem architecto sed sunt deserunt quia nobis. Delectus ab ea repellat unde nihil excepturi voluptatem sapiente.	/images/course_example_image.png	approved	\N	76.82
77e75adb-20e4-495c-beeb-98f275b8224b	308	Course 51	Dolores qui officia cupiditate expedita sapiente. Reiciendis fugiat qui suscipit qui et optio voluptatum iste. Sit eum perferendis perspiciatis vitae quaerat porro. Dolores dolores dolores quas voluptas doloremque expedita distinctio. Aspernatur sit iure voluptas tempora beatae quo tenetur. Inventore nihil nam eos aut veniam sint. Earum nobis illo sed deleniti. Incidunt omnis atque molestiae. Consequuntur vero sunt ab labore. Minima fuga voluptatibus molestias quia aspernatur sit expedita aut.	/images/course_example_image.png	approved	\N	89.95
285bafd9-3fd1-4812-bd1e-1eb54abd8d15	289	Course 52	Temporibus magnam qui corrupti laborum ullam natus et et. Culpa nisi vel iure rerum deleniti sequi quo quos. Voluptas autem ipsum dolorum excepturi. Fugiat nihil saepe consequuntur autem odit. Reiciendis omnis dignissimos ut voluptatem eos dolor. Consequatur voluptatem animi dolorum accusamus qui ullam. Voluptates voluptas quasi esse sapiente aut non. Voluptas dolores omnis nulla ut et. Error dolorum quia iusto fuga. Tempore nostrum nisi sapiente.	/images/course_example_image.png	approved	\N	95.65
0ac35814-5b07-4219-aa80-89c7c6fd3cc8	288	Course 53	Id deserunt voluptatem neque eos veniam. Exercitationem ipsum asperiores numquam perspiciatis aut. Qui est maiores aut error libero enim et. Vel non voluptatem corrupti laboriosam iure. Atque quae esse ut eaque. Molestias assumenda molestias sequi sunt. Sint nulla non aliquid consequuntur consectetur sint quas a. Illum numquam aut voluptates corporis dolor consequatur. Laboriosam voluptate in vel libero. Exercitationem minima laboriosam non et velit neque explicabo.	/images/course_example_image.png	approved	\N	52.4
3b6fe60a-4659-48b8-bbb1-ed3bd62f148f	263	Course 67	Dicta suscipit autem consequatur. Esse dolores repellendus beatae in dolorem eius iure nihil. Sit dignissimos ut aut ut enim. Soluta suscipit odit ea voluptates ut nesciunt eius omnis. Quibusdam sit est provident corporis. Odio beatae occaecati repudiandae doloribus iure non quibusdam. Explicabo accusantium necessitatibus animi soluta maiores et alias. Quis necessitatibus explicabo cupiditate exercitationem. Laborum qui tenetur repudiandae error aut natus aperiam. Et molestiae occaecati velit accusantium sed.	/images/course_example_image.png	approved	\N	50.7
1f99e13f-acd6-4f7a-93ce-8fcad70bca45	275	Course 54	Iste aspernatur quos ullam dolores nobis harum tempore. Ab non quae placeat aut sed id. Quos omnis aspernatur qui dolore qui deserunt neque omnis. Repudiandae nesciunt beatae voluptatem qui aut totam inventore. Voluptatem vel hic aperiam impedit nisi quae. Voluptatem et iure quod quia voluptas numquam omnis. Quae rerum facilis a dolor similique dolores explicabo nostrum. Consequatur labore odio est consequuntur perferendis nostrum voluptas rerum. Neque earum accusamus inventore occaecati. Distinctio quod exercitationem numquam repudiandae occaecati ut in.	/images/course_example_image.png	approved	\N	73.92
3e2ccf51-53e2-4d47-9749-278b0c906d25	325	Course 55	Illo aut sunt perspiciatis vel quisquam ut. Est dolor dolor voluptate nesciunt in quis. Qui ut distinctio et ratione recusandae. Ut consequatur et molestiae iusto qui. Rerum et consectetur ratione nihil minima aut. Libero molestiae omnis unde consequatur quis iusto numquam. Veniam commodi dolorum reiciendis rerum et laborum. Dolor sed temporibus saepe quisquam ab. Reprehenderit delectus libero reiciendis vero dolorem ut hic. Corrupti molestiae quia corrupti aut.	/images/course_example_image.png	approved	\N	55.53
3e2171bb-4900-44dc-95a6-b90778f25513	277	Course 56	Possimus ea et ullam in at aut ipsum. Nemo aut eveniet rerum similique earum saepe pariatur. Est est quis neque vel aperiam. Et sunt atque est qui et quo. Sint ipsa inventore itaque nihil. Optio mollitia similique quis sit molestiae. Maiores quis quia rerum rerum eum. Rem suscipit cumque deserunt repellat similique et atque. Eligendi quibusdam qui iusto assumenda similique. Exercitationem cupiditate numquam quisquam.	/images/course_example_image.png	approved	\N	55.15
180b0506-c433-4118-a5d5-b8f1d67e12c5	284	Course 57	Qui quis quis praesentium aut est. Ad nesciunt nemo voluptas excepturi fuga et omnis. Rerum ea ipsam repudiandae explicabo. Ut necessitatibus et sint maxime repudiandae commodi nisi voluptas. Ad magnam laboriosam sint accusamus neque neque. Illo aliquid hic inventore omnis. Consequatur beatae voluptatum aliquid perspiciatis hic autem repellendus eius. Id placeat natus quis doloribus corrupti minima autem ex. Incidunt aut ad cumque fuga repudiandae ut dolorum. Alias accusantium sint nesciunt possimus.	/images/course_example_image.png	approved	\N	60.7
2ee89b82-742d-401e-b50d-0f56d836ebd1	280	Course 58	Sit commodi id tempora minus amet. Itaque quo quasi quaerat mollitia excepturi sint et consequatur. Dolorem molestiae similique dolorem voluptas aliquam. Nihil et rerum enim doloremque earum veritatis. Neque nesciunt eaque cupiditate enim velit qui maxime. Enim non sint distinctio sit perspiciatis exercitationem. Et reprehenderit autem temporibus velit. Qui vitae inventore id facere perspiciatis necessitatibus laboriosam repudiandae. Nam est quod itaque optio laborum ex. Et perferendis quia totam eos.	/images/course_example_image.png	approved	\N	73.33
7c81dcdb-d6cb-4178-81cb-786c910a4b28	304	Course 59	Rerum harum ratione sapiente voluptatem. Ea aut vel vel praesentium natus. Magnam fugiat quia aut provident. Nostrum est laboriosam incidunt doloremque voluptatem dolores soluta. Quis inventore nisi rerum aspernatur consequuntur. Nam et consequuntur rerum voluptatem. Qui ipsam sed quaerat. Quia nihil eius delectus alias sapiente harum nobis. Dolores et praesentium quod ducimus eligendi qui laboriosam. Dolores dolorem et modi voluptatem et.	/images/course_example_image.png	approved	\N	96.68
2bcd374c-0933-4f1e-a0f7-1cdc369cf820	268	Course 60	Deserunt exercitationem inventore expedita doloribus quia quis nulla. Nostrum quaerat expedita distinctio nisi non tenetur. Asperiores voluptas enim commodi. Quasi ut accusamus ut doloremque sed et quidem. Aut qui voluptatum enim cumque modi. Enim quod molestias eius ut a officiis facilis. Fuga et consectetur expedita dolores. Nihil voluptates consequatur perferendis itaque. Et aut enim quaerat et ea. Voluptatem vel dolores officiis adipisci ducimus laborum nihil numquam.	/images/course_example_image.png	approved	\N	81.8
cc1fc1a2-b893-4cb3-a2d2-5872903a06eb	323	Course 61	Cumque ex ut libero suscipit qui aliquid et. Qui mollitia optio numquam doloremque et aspernatur et. Cupiditate autem excepturi nihil est. Cumque a assumenda id occaecati. Reprehenderit distinctio nihil animi. Natus sit eaque optio repudiandae. Ad non sit quaerat. Nisi repellendus velit in est alias et. Doloremque quia et aut tenetur esse eveniet sunt. Aperiam aut sit et eos.	/images/course_example_image.png	approved	\N	89.47
2a60da79-bdd8-48cd-8368-d6cb8726ca33	283	Course 62	Temporibus mollitia eius debitis rerum ut ea. Ut optio ut dolorum illo. Neque officiis ratione consectetur nihil sapiente ea quae officiis. Aut velit maiores rem modi adipisci laudantium rerum. Nihil non quidem quia unde. Perspiciatis qui at similique adipisci alias autem soluta aut. Error nemo et quasi laudantium nostrum. Sint velit iure eligendi possimus temporibus voluptatem. Minus suscipit officiis quo. Numquam non cum officiis laboriosam.	/images/course_example_image.png	approved	\N	52.17
6268f659-b7a7-4d6f-a9c1-7a539bbf2666	317	Course 63	Aspernatur non id aut. Quisquam mollitia eius fugiat. A molestiae laboriosam deserunt et voluptas. Et ut veniam sunt non. Eum perspiciatis sequi veritatis corporis aut. Voluptates fugit dicta est quia. Voluptas voluptatem aut cumque quo tempore corrupti. Sunt libero omnis et corporis et. Beatae minima velit commodi suscipit velit. Illo incidunt at incidunt quae.	/images/course_example_image.png	approved	\N	60.61
83af701f-37b5-419d-b9a7-ab0b6a303881	297	Course 64	Necessitatibus fugit harum hic nihil qui recusandae. Incidunt ex voluptatem et. Qui fuga unde voluptatem amet et unde ratione. Aperiam nisi ad et expedita commodi porro a. Necessitatibus aut et vel et aut dolor nam. Et harum pariatur aspernatur dolor et animi iste. Reiciendis qui error autem et. Nemo magni sed quasi corrupti fuga velit in. Rerum est quo et ex sed mollitia a voluptatum. Molestiae odio voluptatem ad quaerat voluptatum.	/images/course_example_image.png	approved	\N	94.53
cfb9b5d7-679b-4ffc-bdd7-c0a5ba87d0e0	283	Course 65	Aliquid maiores alias omnis magni in consectetur. Cumque quo repellendus mollitia velit maiores qui. Blanditiis natus ullam consequatur voluptas temporibus. Laborum repudiandae rem omnis dolore et praesentium iste. Velit accusantium aperiam nulla adipisci harum alias. Dolorem incidunt unde voluptate quam eius et dolor occaecati. Quia corporis nobis amet iste aut magnam. Rem blanditiis earum officiis quia molestias vel. Earum fugit eos aliquid vitae maiores. Numquam perferendis autem similique odit velit accusamus.	/images/course_example_image.png	approved	\N	71.93
9bc67eda-a78a-46f7-9dc4-f32933a7df80	282	Course 66	Cum non quaerat debitis tempore libero omnis distinctio totam. Qui cum et consequatur dolorum. Sunt labore at enim adipisci architecto aut cupiditate. Rerum quia praesentium sit occaecati delectus quia. Dignissimos iure in ullam et voluptate non cum. Iste aut iusto eligendi mollitia. Praesentium occaecati eos nemo maxime ut quod. Nobis soluta excepturi pariatur maxime quisquam deserunt placeat nihil. Qui quidem dolorem impedit et dolores quaerat adipisci quod. Voluptatibus facilis cumque similique non asperiores cumque.	/images/course_example_image.png	approved	\N	89.19
0c197781-d730-478e-9fc6-c2905a1912c8	264	Course 68	Necessitatibus magni aut ut repellat. Enim sunt aut ut itaque. Non et aut qui sequi quis consequuntur. Enim vel facilis sunt dolorem architecto. Perspiciatis quo alias sunt. Debitis id et aliquid earum dolorem. Magnam id atque reprehenderit est iure. Et qui ut molestiae soluta. Magni non ut consequatur ea velit. Vero et aut veniam tempore eaque fugit sint distinctio.	/images/course_example_image.png	approved	\N	71.48
9e03071f-7301-4f4a-80c8-797630dd28e8	264	Course 69	Ut consequatur optio quasi natus. Autem voluptas magni eveniet sit ut et hic. Sint dolore assumenda earum aliquid. Quis est vero sunt est. Illum hic et ad et optio exercitationem consectetur omnis. Odio magni fugiat aut natus recusandae consequatur. Molestiae illo est magni ut quasi. Earum quod at deleniti qui suscipit temporibus sit voluptas. Dolorum minus rerum non iste aut nesciunt. Hic et omnis aut numquam consequatur.	/images/course_example_image.png	approved	\N	62.42
53f0a77b-a476-4b20-b462-7b8d6c3d8ae6	289	Course 70	Aut vel voluptas nesciunt odit. Magnam ut quis sequi aut commodi et dolorem recusandae. Repellat sequi cupiditate ut nulla et culpa illo amet. Aut delectus sit qui et. Non magnam dolor rerum ducimus. Cupiditate dolor aut fugit excepturi. Ipsum impedit et omnis sit. Debitis neque eligendi iusto tempora. Non qui ut ut quasi doloribus laboriosam a. Et dolorum aperiam beatae corporis quis provident molestiae voluptas.	/images/course_example_image.png	approved	\N	78.73
04980870-e5b6-49e5-8b37-480beb6ff656	312	Course 71	Sed nihil odit quam voluptas. Est accusamus pariatur voluptas ducimus accusamus vitae quia rerum. Ex omnis corporis soluta rerum doloremque dolores et. Voluptatem quia incidunt et alias dolores. Placeat sunt delectus temporibus aperiam illo et. Blanditiis aliquid ad error. Nulla architecto vitae atque officia. Corrupti omnis dignissimos iusto ex. Deleniti laudantium reprehenderit consectetur est corrupti asperiores. Cum a expedita aliquam natus nostrum.	/images/course_example_image.png	approved	\N	96.34
f531ef61-3e84-4abb-8141-f98bf006d189	307	Course 72	Ea numquam suscipit nesciunt magni deserunt quidem cum. Non nesciunt accusantium ut quis sint voluptas quia. Praesentium et dolorem nisi placeat nesciunt recusandae. Laboriosam mollitia in non at recusandae. Ut voluptatem est molestiae aut exercitationem. Consequatur officia quidem dolorem eum facere omnis blanditiis. Voluptate eum ut nobis quidem. Nemo quia est omnis voluptas saepe ad dolorum esse. Ab ut enim ea voluptas. Voluptatibus voluptas aut in rerum sit beatae.	/images/course_example_image.png	approved	\N	94.35
57c654cb-b1ae-429d-bacc-c38c565d219d	304	Course 73	Voluptatibus dolores vel sit quo dolore incidunt. Repudiandae nostrum et dolores. Qui et et atque similique. Ipsum cum dolor dicta error enim corrupti. Rerum praesentium facilis cupiditate omnis. Quae autem quas iusto in qui minima doloremque. Labore ab qui facilis sed. Et itaque alias distinctio quo incidunt necessitatibus ut. Eos facere provident ipsum qui mollitia soluta est. Praesentium voluptatem quia quia nihil.	/images/course_example_image.png	approved	\N	84.89
9d090d0b-14c3-4b03-b4cf-094c1f5189f0	302	Course 74	Neque assumenda nesciunt quae rem nobis. Quisquam facere in et dolorem. At itaque eos ullam necessitatibus tempora voluptatum quis. In iste mollitia vero nisi aspernatur voluptatibus cumque assumenda. Perferendis et cumque ab molestias ea aperiam. Ipsum consequuntur excepturi ut enim laborum. Sed sequi qui fugiat at qui perspiciatis rerum enim. Non dolorum sit reiciendis minima ut tenetur dolore. Consequatur accusamus eum dignissimos. Est consectetur quo natus est blanditiis eum quo.	/images/course_example_image.png	approved	\N	60.24
915779e6-d6d4-4c90-89da-9f558a9d847f	323	Course 75	Excepturi nostrum atque consequatur ducimus quo perspiciatis. Iste pariatur adipisci est molestiae rem dolorum earum. Eos eos accusamus quidem aut rerum exercitationem. Dolores ut excepturi eius omnis est accusantium. Unde ad similique porro quis delectus. Explicabo et quo nihil. Ipsum est quibusdam expedita repellendus libero ducimus. Alias exercitationem repudiandae doloremque et quis alias deserunt. Qui deleniti minima commodi est quasi sed quod inventore. Earum vero nisi quis omnis dignissimos ut ducimus.	/images/course_example_image.png	approved	\N	81.66
713a15cc-20e5-4f0f-874a-a8d27b356ba7	309	Course 76	Qui et commodi voluptas. Eum ad velit minima soluta velit eum. Cum quis a sit architecto. Laborum voluptas qui et quisquam. Id consequatur cum consectetur. Quos ad minima sint iure incidunt qui voluptatem. Deserunt quos enim architecto exercitationem. Nesciunt neque rerum vel alias. Doloremque rem et ea enim. Vel quo voluptatem eius aperiam saepe nulla consectetur.	/images/course_example_image.png	approved	\N	84.69
b8874757-3a3d-4e72-a53f-180fc523b538	279	Course 77	Impedit dolor quas amet ut error. Et voluptas numquam aut aut. Totam tenetur dolore voluptatem explicabo reprehenderit aut quisquam. Illo omnis temporibus dicta. Nobis enim dicta aut quo repellat eligendi temporibus voluptatem. Aut est nemo nemo quae. Voluptas sunt illo perferendis autem esse. Ea sed voluptatibus praesentium reiciendis facere iusto. Mollitia perspiciatis architecto et sapiente atque quaerat itaque. Quas autem dignissimos omnis ut consequatur molestiae voluptatem.	/images/course_example_image.png	approved	\N	88.16
fbf834ef-ea76-4aed-986e-bd199f342a21	272	Course 78	Reprehenderit cumque nisi sint culpa voluptatem quis reprehenderit. Voluptate illo ipsum vero harum ea totam. Et illo ducimus impedit voluptatem rerum. Facere accusamus quis placeat. Excepturi quo accusamus dolorum rerum quaerat. Omnis placeat adipisci reiciendis in doloremque. Qui quia incidunt expedita nihil a saepe. Praesentium porro excepturi totam sit eum omnis. Tempora ut autem necessitatibus quasi dolor doloribus laudantium. In cum veniam ex est aspernatur accusantium.	/images/course_example_image.png	approved	\N	67.51
2ba099a5-26a2-4426-a820-5b38803e8a95	279	Course 79	Exercitationem ad nihil odit hic modi. Et praesentium iure deleniti reiciendis itaque corrupti. Quas amet asperiores quidem qui dolor ipsum. Quas consequuntur aut fugiat magnam quod quos molestiae sed. Modi inventore quo et ab. Quidem ex cum dignissimos rerum quisquam nihil veritatis. Consequatur minima accusantium placeat qui laudantium. Iure accusamus possimus dolorem. Et sint fugiat omnis maxime. Et tempore culpa velit sed cumque temporibus totam.	/images/course_example_image.png	approved	\N	52.4
8efd743d-fcaa-468c-b3d6-693fc90218df	280	Course 80	Omnis eos quaerat repudiandae sapiente ipsam vel itaque. Tenetur veniam ea id ex. Non quos dolore itaque vel nam repellendus debitis. Commodi autem atque doloribus rerum omnis numquam. Saepe et aliquam excepturi. Quis quam quod explicabo autem magni. Esse rem id magni inventore dolores mollitia qui. Magni voluptate dolore id minus. Reiciendis et molestias quibusdam et totam reiciendis dolor. Quo enim ut voluptatum voluptatum repellendus tempore.	/images/course_example_image.png	approved	\N	66.07
76c52bbf-3785-401e-8769-4a375242e8f1	318	Course 81	Cumque atque id veniam pariatur optio tempore exercitationem. Perspiciatis enim officiis natus et voluptas ea in voluptatum. Cum dignissimos soluta labore molestiae voluptate facilis nihil. Et consequatur atque minus autem voluptates maiores quod. Accusamus veritatis corporis beatae vero laudantium. Vel unde aut ut. In ut rem voluptatem qui quia rerum inventore. Sed ab ea delectus aut voluptatem. Fuga ea ad rem molestias voluptas blanditiis. Natus consequuntur harum velit vitae eos ut.	/images/course_example_image.png	approved	\N	72.55
0d18a042-53a6-4b8a-af6b-f2fbc317db2c	274	Course 82	Atque in labore quo earum sed voluptas vel. Est ut quia ab ea impedit. Quasi reprehenderit non similique nihil. Quae fuga in aspernatur laudantium. Minima quos dignissimos delectus sunt. Eum sed sunt tempore ipsum enim. Dolor voluptatibus pariatur dolores earum voluptatem fugiat officia fugiat. Mollitia nemo qui sit earum. Sint dolores vero pariatur. Explicabo deserunt in quibusdam illum minus dolores optio.	/images/course_example_image.png	approved	\N	98.01
0018f28d-245a-4c69-89de-280927f40cdb	265	Course 83	Asperiores aut maiores non. Nostrum consequatur vel aut est voluptates aut praesentium. Nihil blanditiis provident libero dignissimos animi labore eos. Dolores fugiat esse officiis quia suscipit. Fugit doloribus aperiam minima libero nostrum totam nesciunt beatae. Totam neque possimus sit dolores. Corporis ex quia sequi iste. Ab aliquid recusandae illum explicabo est quod. Esse atque sit molestiae sint. Ut voluptas assumenda alias voluptatem praesentium.	/images/course_example_image.png	approved	\N	56.09
5d3437ca-1563-41da-8eea-c5780e6c355c	290	Course 84	Id magni et ipsam dolor mollitia culpa iusto reiciendis. Dolorem earum quis eius impedit animi consequatur. Incidunt beatae natus consequatur. Alias aut quisquam autem rerum voluptatibus. Veritatis nisi animi optio provident autem necessitatibus. A quia rerum maxime quasi voluptas voluptatem. Sed similique illum libero ipsam. Corrupti molestiae eveniet tenetur. Iure repudiandae accusantium ut corrupti in excepturi sed. Rerum sunt ut nihil magni dolorem provident illum.	/images/course_example_image.png	approved	\N	74.68
aaac4952-a5f7-4ce7-b3b9-68c23c7f7fd2	290	Course 85	Quibusdam qui omnis incidunt odio rerum. Deleniti est veniam quasi amet beatae itaque. Non dolores ducimus ducimus sed aut voluptate. Dolorum voluptas debitis est itaque aut id non. Optio autem provident quibusdam voluptatibus. Aliquid qui sit ab qui libero. Sint enim doloremque non rem ipsum quidem. Animi minima odio magnam. Ad cum similique dolores. Provident sint explicabo recusandae velit molestiae.	/images/course_example_image.png	approved	\N	75.97
d56e0cae-5aa1-4eee-a86e-db0ebbe57e31	303	Course 86	Optio eum illum debitis tempore esse consequatur beatae. Numquam iste repellendus magni et quia fugit eaque enim. Est aut et enim natus impedit alias totam maiores. Officiis ut voluptas quo ut. Quam eaque minima quam ipsam. Ut adipisci ex commodi placeat. Unde a reiciendis iste maiores. Architecto voluptatum nobis delectus recusandae nam. Tempora sed blanditiis ut quidem voluptates nihil adipisci. Esse aut temporibus non similique beatae.	/images/course_example_image.png	approved	\N	85.7
feec659e-b1c7-4fcc-b361-8f2b73b08e96	292	Course 87	Saepe aperiam sit debitis ut cum. Est repellendus voluptatibus quo ratione a commodi et nihil. Doloremque quia ut non. Voluptates et et similique ipsam ullam eum enim vel. Officiis laborum eum aperiam et iste ratione consequatur. Ab neque esse eaque tenetur optio. Aliquam et doloribus fugit consequatur. Exercitationem distinctio aliquam totam vel vel et excepturi. Dolores placeat dolor autem laborum voluptas enim. Ut hic et voluptates velit.	/images/course_example_image.png	approved	\N	73.36
ce905ec9-52fa-44e3-ae76-2b54c31750cd	267	Course 88	Natus quam excepturi quia. Esse maxime asperiores molestias soluta magnam exercitationem. Ut esse quo aut a dolor. Voluptas in voluptatibus eum quia voluptas occaecati. Iste minus eum provident ut aut ab reiciendis sint. Tenetur asperiores facilis et libero. Facere accusantium est repellat aliquam consequuntur minima quasi. Porro dolor aut ea fugiat tempora esse ut. Iure officiis fuga illo porro. Consectetur laborum aliquid exercitationem omnis dignissimos.	/images/course_example_image.png	approved	\N	65.79
ef87ad36-e9a7-4760-9e72-b79d8518d561	319	Course 89	Quo totam soluta autem veritatis at ad qui. Qui occaecati quas excepturi voluptatum. Debitis est ratione in provident hic facilis. Consectetur ut facilis quo itaque ut ducimus iure aut. Et similique neque quo sed. Quis quam sed necessitatibus a. Rem illum ea sed. Iure et asperiores et nihil aut. Soluta aperiam aspernatur omnis ad sed voluptate. Aut dolor ut repellat eum.	/images/course_example_image.png	approved	\N	93.15
8773681b-a255-4227-98bb-0cf5c19cbfb6	313	Course 90	Temporibus eos harum mollitia molestias qui. Quos ut qui in culpa perferendis aut sunt. Dicta ab autem assumenda animi in molestiae mollitia quos. Voluptatum qui aut velit voluptas sunt et suscipit voluptatem. Atque accusantium animi placeat cupiditate aut eum explicabo. Ab eos rerum temporibus aliquid nulla aliquid. Iure placeat perspiciatis voluptatibus enim aliquid sint error. Voluptatem quia est omnis occaecati illum. Repellendus iure adipisci ipsam accusamus voluptate inventore iure. Iste dolore est laudantium quis.	/images/course_example_image.png	approved	\N	72.05
4e8ceb76-fe35-44f2-a82f-e205aec183c7	289	Course 91	Soluta et aut unde corrupti. Qui explicabo laborum tempora placeat quae eaque qui. Aliquid placeat atque inventore est beatae at. Unde ipsam nihil dolorem. Commodi veniam velit temporibus rerum. Est sunt necessitatibus totam quis sit sit doloremque. Qui aliquam ipsa et numquam molestias debitis expedita. Omnis ut a amet unde id animi exercitationem cumque. Nostrum a in ea voluptas quo tempore. Sunt ea qui totam ea tempore.	/images/course_example_image.png	approved	\N	97.44
249a333a-041a-464c-a858-d796e0fc7716	309	Course 92	Voluptatem quis et sunt possimus. Aut cum quibusdam blanditiis eius quia. Blanditiis possimus similique qui qui soluta mollitia. Autem qui reiciendis et aliquid facilis cumque. Sequi quis quibusdam et quae vel. Eos quia voluptatibus accusantium recusandae eos. Et aut aut non id consequatur. Totam ut ex doloribus aut dolorem. Explicabo et et ducimus nesciunt cupiditate architecto sed. Autem possimus alias aut nisi nemo.	/images/course_example_image.png	approved	\N	72.11
199b5d5e-1639-4302-8ee2-869f6589ef83	304	Course 93	Sequi voluptatem sequi laborum eligendi. Consectetur impedit repellendus voluptate repellat maiores. Eaque atque id minus laudantium sint repellat sint. Maiores dolor non minus iusto. Expedita omnis inventore dolor commodi. Similique nostrum qui minima aspernatur dicta. Et consequatur et in aut nihil. Est recusandae distinctio facere corporis tempora inventore. Dolor in sequi cum et voluptatem facilis. Voluptatem quo sed corporis mollitia fugit.	/images/course_example_image.png	approved	\N	53.82
0df8a323-01fc-4f5a-b92c-ceaf6119003e	268	Course 94	Aut et aut quia ratione officia voluptatum fugiat. Est qui corrupti consequatur. Tempore rerum numquam excepturi optio nobis porro qui tempore. Mollitia voluptas illum voluptas eius voluptatem. Aut distinctio ratione magni aliquid quia dolore. Cumque perferendis ullam eum dolor dolores ut commodi. Quia consequatur dignissimos delectus dolor nihil neque. Quo sequi perferendis aut ad vel. Tempora est rem voluptatibus dolorem nemo enim fugit. Pariatur et accusamus ducimus incidunt corrupti facilis officia.	/images/course_example_image.png	approved	\N	69.75
dedcdcd9-6dd3-4d54-88bb-1db22991e19c	289	Course 95	Id dignissimos assumenda incidunt ea. Neque architecto voluptatem iste incidunt. Neque sit sequi et et temporibus fugit quisquam. Tempora quia unde fugiat tempore. Ex veritatis sapiente qui cum quis. Cum voluptas sed nobis eaque ex. Rerum vel ad quos magni ipsa. Earum dignissimos quo consectetur nihil sed voluptas. Beatae quis id sed quos facilis sint mollitia. Dolores dolores illo nostrum recusandae nihil natus molestias.	/images/course_example_image.png	approved	\N	54.13
814f4998-09a1-4752-9095-df4c1a3718a6	300	Course 96	Nihil tempora repudiandae omnis tempora illum accusamus. Fuga molestias est exercitationem voluptas. Praesentium id id consequatur dolorum et. Aut inventore officiis laboriosam tempora ab. Dicta est omnis ea alias. Rem commodi dolore laboriosam ea explicabo temporibus velit. Omnis facere est nihil. Perferendis vel explicabo qui nostrum. Quo est excepturi natus non est. Laudantium aliquam animi eveniet voluptas deleniti.	/images/course_example_image.png	approved	\N	87.83
73f45241-2f28-4b1c-879c-46ecc6ec9055	298	Course 97	Laudantium unde provident eum voluptate esse. Sint suscipit non commodi voluptate architecto. Id error autem et molestiae deserunt aut omnis. Nemo in maiores ipsa voluptate laborum. Sapiente odit soluta ut fugit. Quo quos sed autem excepturi incidunt sit. Voluptatem cum dolores et modi officia minima qui. Similique saepe dolor numquam maiores optio. Et ipsum omnis et et libero. Labore sunt in quia consequatur rerum.	/images/course_example_image.png	approved	\N	60.35
138fd8e5-81b6-4fa1-888d-0e792fbc2827	305	Course 98	Repellendus veniam nulla illum id quia laudantium assumenda. Perspiciatis sunt dicta in alias minima quo est vero. Ut expedita in provident consequatur cumque est. Sint non corrupti assumenda voluptatem est. Aliquid autem enim non corrupti dolore quo beatae. Et vel rerum velit animi. Explicabo fugiat alias voluptatem vero qui illo. Similique enim voluptas beatae veniam aut ex voluptates quia. Ea sed beatae dignissimos fugiat quae magni. Non et molestias qui omnis.	/images/course_example_image.png	approved	\N	80.01
8bfbcabd-027d-476c-a38d-7400a924663f	297	Course 99	Rem sed ipsam quia sit et amet nobis. Quo est nihil laboriosam quia ea. Necessitatibus at neque vero ducimus sunt dolorem ipsam. Porro excepturi inventore voluptatem illum dolores aut qui ut. Ad quos vel aut quam alias voluptas. Qui placeat est suscipit. Molestias mollitia omnis omnis non. Iste omnis aliquid saepe quos. Ea quis sit nam amet pariatur enim magnam. Vitae fugit minima amet sit.	/images/course_example_image.png	approved	\N	80.73
b5f9811e-96e4-4af6-9189-89413afbebc6	300	Course 100	In dolores voluptatem facere. Amet illum in omnis aut aut architecto deserunt. Dolore provident veniam ab quas nam eum provident. Nulla corporis debitis quae inventore corporis quasi cupiditate. Reiciendis unde consectetur inventore quidem. In ea mollitia sunt in. Doloribus eos sit itaque neque. Molestias repudiandae voluptatum consectetur unde. Perferendis aspernatur libero cum architecto nisi amet culpa. Vitae quo dolore accusamus.	/images/course_example_image.png	approved	\N	63.25
\.


--
-- TOC entry 4923 (class 0 OID 16640)
-- Dependencies: 215
-- Data for Name: doctrine_migration_versions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctrine_migration_versions (version, executed_at, execution_time) FROM stdin;
DoctrineMigrations\\Version20241213211842	2024-12-13 21:18:55	138
DoctrineMigrations\\Version20241213212437	2024-12-13 21:24:43	5
DoctrineMigrations\\Version20241213213507	2024-12-13 21:35:13	5
\.


--
-- TOC entry 4940 (class 0 OID 16709)
-- Dependencies: 232
-- Data for Name: episode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.episode (id, chapter_id, name, description, video_path, image_path, public_image_id, public_video_id, is_free_to_watch) FROM stdin;
1201	401	Episode 1 of Course 1	Maiores doloribus repudiandae est voluptate vitae laudantium. Et occaecati voluptatem ea ab eos.	\N	\N	\N	\N	t
1202	401	Episode 2 of Course 1	Laudantium temporibus recusandae placeat voluptas suscipit eaque omnis. Voluptatum corrupti aperiam non voluptatem inventore qui totam. Nemo ex quo molestiae facere eaque ut.	\N	\N	\N	\N	f
1203	401	Episode 3 of Course 1	A temporibus eum ducimus adipisci amet amet. Expedita est fugit voluptatem nisi iusto inventore qui. Dolorem explicabo explicabo aut voluptatibus inventore dolores.	\N	\N	\N	\N	f
1204	402	Episode 1 of Course 2	Odio occaecati earum ipsam libero. Blanditiis ut commodi velit dicta in.	\N	\N	\N	\N	t
1205	402	Episode 2 of Course 2	Aliquid ad quia natus consequatur. Sequi aut nobis voluptas quisquam voluptatum cupiditate pariatur. Deleniti eos tempore voluptas et praesentium ullam aspernatur.	\N	\N	\N	\N	f
1206	402	Episode 3 of Course 2	Impedit placeat magnam voluptates sunt quibusdam harum. Perspiciatis itaque asperiores illo omnis. Provident voluptatum voluptatem eius natus impedit aut.	\N	\N	\N	\N	f
1207	403	Episode 1 of Course 3	Voluptas expedita explicabo ut tempore temporibus iste. Perferendis et modi qui nemo fugit alias cupiditate perferendis.	\N	\N	\N	\N	t
1208	403	Episode 2 of Course 3	Eligendi mollitia consequatur laboriosam aut fugit expedita est. Non et ut vel mollitia et. Sed et qui unde incidunt.	\N	\N	\N	\N	f
1209	403	Episode 3 of Course 3	Iusto dolores est et exercitationem. Voluptatem nam quia et porro. Mollitia provident nam ipsa adipisci illum.	\N	\N	\N	\N	f
1210	404	Episode 1 of Course 4	Hic et corporis porro neque aspernatur quod. Praesentium nihil iure aut et rerum dolores corrupti ut.	\N	\N	\N	\N	t
1211	404	Episode 2 of Course 4	Doloribus iure error occaecati sit praesentium alias veniam. Placeat vel ducimus dolorem iusto non sunt commodi. Vel dolores reiciendis repudiandae deleniti voluptatem saepe et.	\N	\N	\N	\N	f
1212	404	Episode 3 of Course 4	Alias et ipsam dicta ut et et. Aperiam nobis et iure. Odio similique animi nostrum repellat itaque voluptatem quia.	\N	\N	\N	\N	f
1213	405	Episode 1 of Course 5	Libero illo et quam illum. Aliquam quia accusantium quis debitis.	\N	\N	\N	\N	t
1214	405	Episode 2 of Course 5	Aperiam necessitatibus fugit ex eaque. Nihil voluptatum ut non. Ut optio quis delectus quos quia quis placeat doloremque.	\N	\N	\N	\N	f
1215	405	Episode 3 of Course 5	Iste commodi ipsa aut voluptatibus. Qui molestiae voluptas nihil consectetur similique voluptas. Esse reprehenderit qui inventore sapiente omnis.	\N	\N	\N	\N	f
1216	406	Episode 1 of Course 6	Molestiae eaque et suscipit ipsam quam neque et. Et laboriosam dolorem minus adipisci.	\N	\N	\N	\N	t
1217	406	Episode 2 of Course 6	Vel reiciendis veritatis architecto rem debitis est molestiae. Quae molestias ad non fugit aperiam. Ut tenetur pariatur quo.	\N	\N	\N	\N	f
1218	406	Episode 3 of Course 6	Amet libero placeat voluptas nemo. Vero ut temporibus quis eius soluta commodi. Deleniti doloremque sapiente neque vero aut aut ut.	\N	\N	\N	\N	f
1219	407	Episode 1 of Course 7	Rerum itaque pariatur deserunt. Qui vel voluptas qui est.	\N	\N	\N	\N	t
1220	407	Episode 2 of Course 7	Explicabo velit in dolores eveniet eius voluptas voluptatem eos. Quibusdam quia mollitia cupiditate magnam ea dignissimos facilis. In debitis consectetur debitis quia explicabo facilis et quibusdam.	\N	\N	\N	\N	f
1221	407	Episode 3 of Course 7	Qui eveniet perspiciatis hic blanditiis mollitia eos. Amet expedita voluptate et amet enim quibusdam ea. Illo et voluptatem voluptatum eius totam sit.	\N	\N	\N	\N	f
1222	408	Episode 1 of Course 8	Est deserunt nobis aut laboriosam. Ut et voluptatibus tenetur dignissimos sequi qui nulla.	\N	\N	\N	\N	t
1223	408	Episode 2 of Course 8	Iste quis labore necessitatibus placeat fugiat illum. Tenetur inventore cupiditate dolorem. Laborum sed est dolorem blanditiis inventore libero numquam unde.	\N	\N	\N	\N	f
1224	408	Episode 3 of Course 8	Ea aut officia nulla rem ipsa pariatur neque. Velit quisquam tenetur voluptate voluptatibus molestiae dicta nemo. Consequatur quidem est dolor quia temporibus ut facilis.	\N	\N	\N	\N	f
1225	409	Episode 1 of Course 9	Ducimus ratione quia earum distinctio. Minus fugiat voluptas suscipit minima labore nihil.	\N	\N	\N	\N	t
1226	409	Episode 2 of Course 9	In voluptate nisi reiciendis hic nulla iusto. Perferendis ut voluptatem delectus fugiat aliquam. In eos eum illo rerum et.	\N	\N	\N	\N	f
1227	409	Episode 3 of Course 9	Voluptatibus quisquam vitae commodi. Quas et quis debitis error quos et. Culpa et fuga doloremque et asperiores.	\N	\N	\N	\N	f
1228	410	Episode 1 of Course 10	Et laboriosam non nesciunt doloremque. Minima quia quia cumque labore quis ut.	\N	\N	\N	\N	t
1229	410	Episode 2 of Course 10	Maiores quos minima eveniet officiis incidunt. Rerum et animi et dignissimos labore exercitationem. Et dolores deserunt accusamus debitis.	\N	\N	\N	\N	f
1230	410	Episode 3 of Course 10	Nisi ullam a aperiam incidunt quibusdam. A quia praesentium qui nisi incidunt. Neque porro esse sequi aliquid dolor esse.	\N	\N	\N	\N	f
1231	411	Episode 1 of Course 11	Quisquam minus similique et reiciendis. Explicabo ipsum qui sed impedit natus possimus provident.	\N	\N	\N	\N	t
1232	411	Episode 2 of Course 11	Quod cumque velit libero earum voluptatem qui. Eum consectetur voluptate dolores accusantium. Odio delectus maiores qui exercitationem laudantium beatae.	\N	\N	\N	\N	f
1233	411	Episode 3 of Course 11	Perferendis eius deserunt veniam laboriosam sit quod et hic. Officia sit commodi mollitia aperiam. Laboriosam distinctio molestiae perspiciatis porro quos recusandae.	\N	\N	\N	\N	f
1234	412	Episode 1 of Course 12	Odio dolores inventore dolor saepe quaerat. Consequatur saepe exercitationem qui.	\N	\N	\N	\N	t
1235	412	Episode 2 of Course 12	Tempora atque ullam unde perferendis voluptas aut. Voluptas eum vero rerum ipsum assumenda eveniet eligendi. Id dolores rerum eaque laudantium est.	\N	\N	\N	\N	f
1236	412	Episode 3 of Course 12	Occaecati nulla necessitatibus sint. Et officia perspiciatis hic voluptates doloremque incidunt eius voluptate. Nihil magni consequatur aut ducimus nostrum.	\N	\N	\N	\N	f
1237	413	Episode 1 of Course 13	Et aut non et rerum. Voluptate explicabo repellat suscipit labore commodi asperiores et quod.	\N	\N	\N	\N	t
1238	413	Episode 2 of Course 13	Rerum nam consequatur iure eius. Sit qui labore blanditiis veniam et earum sapiente sint. Nostrum ea explicabo aut architecto ratione et.	\N	\N	\N	\N	f
1239	413	Episode 3 of Course 13	Odit natus qui iste error est voluptas. Facilis aut reprehenderit vitae molestiae quaerat corrupti. Expedita repellendus ut perspiciatis et.	\N	\N	\N	\N	f
1240	414	Episode 1 of Course 14	Rerum distinctio est necessitatibus quisquam rerum est. Perferendis nulla provident occaecati sit ab.	\N	\N	\N	\N	t
1241	414	Episode 2 of Course 14	Officiis quisquam voluptate repellendus autem aliquam. Quo qui soluta dolore. Alias optio qui occaecati recusandae quia molestiae.	\N	\N	\N	\N	f
1242	414	Episode 3 of Course 14	Qui placeat delectus eius est excepturi quia. Repellendus ut maxime facere deserunt deleniti. Excepturi a consequatur nesciunt rerum occaecati sit perspiciatis.	\N	\N	\N	\N	f
1243	415	Episode 1 of Course 15	Enim dolor voluptatem sed in qui est. Expedita odio sed deleniti dolores.	\N	\N	\N	\N	t
1244	415	Episode 2 of Course 15	At libero quos debitis autem voluptas quis. Harum occaecati in maiores veniam rerum dolorem maiores. Repellendus maxime et ipsa eum libero.	\N	\N	\N	\N	f
1245	415	Episode 3 of Course 15	Aut tenetur minus quae dolorem quo harum qui. Impedit ipsam nostrum et fuga molestiae quaerat. Ipsum nesciunt tenetur esse id magnam omnis aut nostrum.	\N	\N	\N	\N	f
1246	416	Episode 1 of Course 16	Dolores impedit quidem ipsam sapiente et. Debitis fugiat maxime quo et sed.	\N	\N	\N	\N	t
1247	416	Episode 2 of Course 16	Tenetur deleniti maiores nemo. Qui vel consequuntur et dolores inventore fuga soluta corrupti. Optio expedita ad est aliquid.	\N	\N	\N	\N	f
1248	416	Episode 3 of Course 16	Quisquam molestiae esse totam ipsam est doloribus. Facilis vitae eum voluptas magni aut corrupti. Atque dolorum aspernatur mollitia autem perferendis id.	\N	\N	\N	\N	f
1249	417	Episode 1 of Course 17	Iure consectetur vel dolor veritatis unde. Numquam ut dolore autem aut.	\N	\N	\N	\N	t
1250	417	Episode 2 of Course 17	Qui voluptatum hic nesciunt magnam aliquam impedit. Non odit error quis nostrum. Ut vero voluptate explicabo suscipit a dolorem.	\N	\N	\N	\N	f
1251	417	Episode 3 of Course 17	Voluptatem dolorem quae molestiae eligendi et quia. Et et qui fugiat quod ducimus voluptas odit. Animi dicta amet vel iusto similique quia.	\N	\N	\N	\N	f
1252	418	Episode 1 of Course 18	Est minus beatae architecto quos velit. Et veniam voluptate necessitatibus suscipit.	\N	\N	\N	\N	t
1253	418	Episode 2 of Course 18	Illo facere fuga placeat qui adipisci asperiores consequuntur. Rerum nesciunt est ut dolores impedit. Et perspiciatis fugit reprehenderit amet minima ea dicta.	\N	\N	\N	\N	f
1254	418	Episode 3 of Course 18	Nihil blanditiis fugit ut exercitationem fugiat quod culpa. Dolore inventore voluptatem quo vel aut. Voluptas nihil voluptates cumque assumenda.	\N	\N	\N	\N	f
1255	419	Episode 1 of Course 19	Cupiditate commodi atque non. Voluptatibus fugit ad in ratione ut culpa expedita.	\N	\N	\N	\N	t
1256	419	Episode 2 of Course 19	Enim cum repellendus molestiae vitae praesentium. Maxime doloremque facilis esse quo voluptas eveniet ratione. Accusamus distinctio nulla laborum.	\N	\N	\N	\N	f
1257	419	Episode 3 of Course 19	Molestiae saepe ut ut unde. Et ad voluptatum modi et odit. Nihil ea iusto est.	\N	\N	\N	\N	f
1258	420	Episode 1 of Course 20	Ipsam quis molestias aut est. Autem nemo aliquid enim praesentium sunt.	\N	\N	\N	\N	t
1259	420	Episode 2 of Course 20	Praesentium corrupti reprehenderit ut odit aperiam. Velit distinctio sed quam earum provident reiciendis eos. Impedit ea et optio et omnis accusamus rerum.	\N	\N	\N	\N	f
1260	420	Episode 3 of Course 20	Porro nostrum adipisci ipsam est. Facere nostrum repudiandae saepe corporis. Natus odio consequuntur eius in similique in.	\N	\N	\N	\N	f
1261	421	Episode 1 of Course 21	Ipsam enim provident quibusdam. Dolorem ratione voluptatem beatae iste.	\N	\N	\N	\N	t
1262	421	Episode 2 of Course 21	Fuga et deserunt et assumenda veniam. Voluptatibus odio atque eos minus. Error ea in iste.	\N	\N	\N	\N	f
1263	421	Episode 3 of Course 21	Qui labore aut omnis ea nulla. Dolorem provident maxime saepe ea. Voluptatibus alias sint reiciendis voluptates dolores ut.	\N	\N	\N	\N	f
1264	422	Episode 1 of Course 22	Qui sint voluptas neque sed voluptates porro nam incidunt. Ducimus sapiente animi enim.	\N	\N	\N	\N	t
1265	422	Episode 2 of Course 22	Quia quo vero fugit expedita. Commodi natus minima sed nesciunt. Qui eius ipsa quidem sunt.	\N	\N	\N	\N	f
1266	422	Episode 3 of Course 22	Omnis voluptas repudiandae dolor quod. Fugit ipsam aut nisi dolorem corrupti illo dolorem qui. Quam natus atque nam aspernatur dolores.	\N	\N	\N	\N	f
1267	423	Episode 1 of Course 23	Molestias et sunt aut enim. Aliquam quia vel iure voluptatem.	\N	\N	\N	\N	t
1268	423	Episode 2 of Course 23	Autem quasi odio fuga. Earum rerum aut quo assumenda illo fuga suscipit. Necessitatibus aut sed voluptatem quasi dignissimos quibusdam.	\N	\N	\N	\N	f
1269	423	Episode 3 of Course 23	Voluptate aperiam nulla sint ipsa ut sunt vero. Iste repellat iusto voluptates adipisci. Et quia aut quam eum qui est.	\N	\N	\N	\N	f
1270	424	Episode 1 of Course 24	Quo fugiat quo dolores ipsam eaque. Ab reiciendis autem saepe in placeat.	\N	\N	\N	\N	t
1271	424	Episode 2 of Course 24	Architecto velit ratione eveniet aut laborum rerum repellendus. Eum officiis maiores dolorem error et. Eum maxime cumque similique optio in id.	\N	\N	\N	\N	f
1272	424	Episode 3 of Course 24	Quod officiis et doloremque minus. Est quidem laudantium dicta quia quam dolorem. Labore illum incidunt eum sunt rerum.	\N	\N	\N	\N	f
1273	425	Episode 1 of Course 25	Ut asperiores aliquid eum omnis deleniti. Aut necessitatibus fugiat enim nostrum enim libero et.	\N	\N	\N	\N	t
1274	425	Episode 2 of Course 25	Et et illo iste dolores. Impedit quo temporibus saepe. Ad error quam consequatur.	\N	\N	\N	\N	f
1275	425	Episode 3 of Course 25	Officia mollitia labore deleniti libero qui accusamus assumenda. Et eum officia non et sint incidunt omnis. Voluptatum earum eius consectetur perspiciatis pariatur alias tenetur et.	\N	\N	\N	\N	f
1276	426	Episode 1 of Course 26	Illo dolores ut autem. Ea saepe ut sit accusantium recusandae.	\N	\N	\N	\N	t
1277	426	Episode 2 of Course 26	Dolorum accusamus quos nihil non. Voluptatem est dolorum laborum recusandae ducimus minus atque hic. Velit eaque magni rem aliquid.	\N	\N	\N	\N	f
1278	426	Episode 3 of Course 26	Repellendus quasi et et nemo quasi dolores. Autem saepe officia molestias consequuntur facere asperiores dolor. Dolores mollitia exercitationem alias et nulla sunt error.	\N	\N	\N	\N	f
1279	427	Episode 1 of Course 27	Non autem occaecati doloribus dolorem. Quia quibusdam ad alias id maiores consequatur dolorem.	\N	\N	\N	\N	t
1280	427	Episode 2 of Course 27	Eos in in itaque eum quos officia. Aspernatur nulla tempore eos eos atque quia rerum. Facilis eligendi sunt asperiores reprehenderit nihil possimus.	\N	\N	\N	\N	f
1281	427	Episode 3 of Course 27	Dolores beatae ratione ut voluptas in. Cumque et vitae fugit id ratione consectetur harum. Quidem qui soluta soluta minima vel in.	\N	\N	\N	\N	f
1282	428	Episode 1 of Course 28	Nostrum voluptatem consectetur odio recusandae ea eveniet. Qui voluptatibus aut est omnis enim voluptas nostrum similique.	\N	\N	\N	\N	t
1283	428	Episode 2 of Course 28	Doloremque commodi voluptas sunt sit molestiae. Voluptas deleniti omnis qui nisi. Et vero dignissimos rerum nostrum non.	\N	\N	\N	\N	f
1284	428	Episode 3 of Course 28	Sint et veniam placeat vitae et sunt. Perferendis tempora laboriosam impedit ut commodi aliquid nam. Doloribus accusamus quasi optio.	\N	\N	\N	\N	f
1285	429	Episode 1 of Course 29	Consequatur suscipit accusantium natus beatae autem. Quo voluptatem amet saepe.	\N	\N	\N	\N	t
1286	429	Episode 2 of Course 29	Veniam animi voluptas ut nihil fugiat officiis sint iusto. Illum rem non velit. Sapiente consectetur reiciendis aut officia voluptas non quia.	\N	\N	\N	\N	f
1287	429	Episode 3 of Course 29	Deleniti porro saepe placeat laboriosam minus deleniti accusamus. Consequuntur nobis sint doloribus. Corrupti iusto officia suscipit unde iure sequi eum.	\N	\N	\N	\N	f
1288	430	Episode 1 of Course 30	Et libero voluptate quo aut culpa iusto numquam quia. Reiciendis placeat officia doloremque et illum assumenda.	\N	\N	\N	\N	t
1289	430	Episode 2 of Course 30	Voluptatem itaque minus dolore non. Ducimus et quis aperiam harum corporis necessitatibus. Sunt cum modi consequatur.	\N	\N	\N	\N	f
1290	430	Episode 3 of Course 30	Maxime doloremque quaerat voluptates rerum ipsum veritatis. Dolor illum sed impedit assumenda. Accusantium reiciendis ut sequi.	\N	\N	\N	\N	f
1291	431	Episode 1 of Course 31	Aut voluptatum et ipsam velit itaque repellat. Officia porro et optio quo.	\N	\N	\N	\N	t
1292	431	Episode 2 of Course 31	Dignissimos commodi eius non ullam id sunt praesentium incidunt. Eaque dolore repudiandae a. Quia voluptas sunt asperiores minima perspiciatis.	\N	\N	\N	\N	f
1293	431	Episode 3 of Course 31	Animi pariatur sit fugiat. Ut doloremque illo et et voluptatem vel officiis. Et sit suscipit rem quam tempore repellendus qui nihil.	\N	\N	\N	\N	f
1294	432	Episode 1 of Course 32	Modi aut quis ratione fugiat beatae et occaecati. Repudiandae debitis dolorum et iusto vel libero velit.	\N	\N	\N	\N	t
1295	432	Episode 2 of Course 32	Amet error natus voluptas soluta non nihil. Et et ipsum qui eius temporibus. Enim quis quibusdam quas eligendi inventore distinctio dolore et.	\N	\N	\N	\N	f
1296	432	Episode 3 of Course 32	Earum assumenda reprehenderit in. Ad illum deserunt sit rerum. Neque id sed sed quos.	\N	\N	\N	\N	f
1297	433	Episode 1 of Course 33	Aut inventore ipsam sequi nesciunt. Minima exercitationem dignissimos cum incidunt.	\N	\N	\N	\N	t
1298	433	Episode 2 of Course 33	Rerum voluptas facere ad vero repellendus asperiores. Itaque minus dolores ut aut corrupti reiciendis vitae atque. Amet dolores accusantium voluptate expedita aliquid et aut quam.	\N	\N	\N	\N	f
1299	433	Episode 3 of Course 33	Sunt eligendi quo enim. Est minus rerum ut repellat soluta eum. Voluptas voluptatum libero quia incidunt blanditiis.	\N	\N	\N	\N	f
1300	434	Episode 1 of Course 34	Deserunt ut reprehenderit ut. Veniam fuga fuga occaecati accusantium fuga iusto saepe.	\N	\N	\N	\N	t
1301	434	Episode 2 of Course 34	Error non ex expedita atque enim sit. Sapiente sunt rerum ut accusamus repellat. Consequuntur velit reprehenderit ullam laudantium fugit.	\N	\N	\N	\N	f
1302	434	Episode 3 of Course 34	Voluptas nostrum est dolorum et eos non sed. Quasi quibusdam quia omnis ipsam magnam. Ut culpa doloremque voluptatem illo debitis molestiae.	\N	\N	\N	\N	f
1303	435	Episode 1 of Course 35	Libero sed rerum aut est beatae qui placeat. Et accusamus ullam dolorem.	\N	\N	\N	\N	t
1304	435	Episode 2 of Course 35	Fugit accusantium excepturi est. Illo nihil eligendi dolor quis sint consequatur. Inventore nihil autem tenetur pariatur incidunt illum.	\N	\N	\N	\N	f
1305	435	Episode 3 of Course 35	Iste eaque explicabo maiores eveniet. Expedita repudiandae accusantium velit. Praesentium dolore ut ipsam.	\N	\N	\N	\N	f
1306	436	Episode 1 of Course 36	Saepe consequatur atque eum quo est sequi nam aperiam. Aut distinctio sequi saepe a voluptatem libero.	\N	\N	\N	\N	t
1307	436	Episode 2 of Course 36	In aut omnis unde officia sint inventore rem. Reprehenderit enim non et mollitia. Sapiente eum cumque deserunt quibusdam quia dolor rem nobis.	\N	\N	\N	\N	f
1308	436	Episode 3 of Course 36	Sunt ipsam quae sed dolores quas quaerat. Suscipit dignissimos qui pariatur aliquid provident occaecati in. Dolorum omnis ducimus omnis nobis dolor eligendi nihil.	\N	\N	\N	\N	f
1309	437	Episode 1 of Course 37	Non ducimus necessitatibus inventore et veniam a temporibus. Accusantium totam provident vero voluptatem voluptatem.	\N	\N	\N	\N	t
1310	437	Episode 2 of Course 37	Aperiam at quisquam reiciendis. Ipsum veritatis vero quibusdam. Nulla sit reiciendis natus a asperiores tempora praesentium.	\N	\N	\N	\N	f
1311	437	Episode 3 of Course 37	Iure et libero quo aut ut incidunt. Cumque delectus perferendis officia eaque id et. Ut eligendi molestiae maiores eaque repellat molestias repudiandae.	\N	\N	\N	\N	f
1312	438	Episode 1 of Course 38	Accusantium quasi dignissimos ipsa consectetur in voluptatem corrupti. Dolorem nihil sit voluptas expedita cupiditate.	\N	\N	\N	\N	t
1313	438	Episode 2 of Course 38	Ea ducimus veritatis ut amet eius. Voluptate quae dolorem sapiente nihil explicabo sit. Omnis repellat quo nihil.	\N	\N	\N	\N	f
1314	438	Episode 3 of Course 38	Nam optio sint ut dolor magnam reprehenderit libero. Harum nobis vel nemo cupiditate quia beatae eligendi. Quia voluptatibus sed doloremque modi.	\N	\N	\N	\N	f
1315	439	Episode 1 of Course 39	Qui tempore autem ratione cum sunt modi. Repellendus neque et laborum ullam occaecati qui ex.	\N	\N	\N	\N	t
1316	439	Episode 2 of Course 39	Error reiciendis officiis sit architecto. Perferendis iste illum eos eaque et. Rerum itaque dolore doloribus quod explicabo est quo.	\N	\N	\N	\N	f
1317	439	Episode 3 of Course 39	Sit repellat distinctio deleniti dolor occaecati. Voluptatem nihil voluptate qui eos praesentium sint quia. Enim autem quidem illo aliquam fuga.	\N	\N	\N	\N	f
1318	440	Episode 1 of Course 40	Totam adipisci omnis dignissimos aspernatur. Aut atque nobis tenetur quos veritatis consectetur aut.	\N	\N	\N	\N	t
1319	440	Episode 2 of Course 40	Dolores pariatur nostrum impedit. Blanditiis non animi aut veniam et. Soluta similique quis molestiae odio labore sit at dolorum.	\N	\N	\N	\N	f
1320	440	Episode 3 of Course 40	Et eveniet accusantium voluptatem voluptatum. Est vero voluptatibus fuga expedita soluta occaecati repellendus tempore. Voluptatem commodi cupiditate reprehenderit repellendus.	\N	\N	\N	\N	f
1321	441	Episode 1 of Course 41	Dolores perferendis provident doloribus. Explicabo aut incidunt itaque quidem quaerat.	\N	\N	\N	\N	t
1322	441	Episode 2 of Course 41	Amet natus aliquam sunt molestiae eius dignissimos quibusdam. Harum et et voluptas qui voluptatem sint. Quo et qui sit eos.	\N	\N	\N	\N	f
1323	441	Episode 3 of Course 41	Facere fugit temporibus eum eum ut unde hic. Nobis at perspiciatis natus non quasi ullam quod. Et eum aliquam vel.	\N	\N	\N	\N	f
1324	442	Episode 1 of Course 42	Corporis sit a quibusdam doloribus. Eius sed rerum eum.	\N	\N	\N	\N	t
1325	442	Episode 2 of Course 42	In sit qui aliquid occaecati id. Repellendus praesentium fuga ea libero magni eum vel vero. Aut numquam recusandae est ut assumenda.	\N	\N	\N	\N	f
1326	442	Episode 3 of Course 42	Qui quibusdam dolorum iure odio. Sunt voluptas cupiditate et mollitia quibusdam. Adipisci ratione rerum numquam et earum laboriosam.	\N	\N	\N	\N	f
1327	443	Episode 1 of Course 43	Laborum totam aut officia suscipit. Eos natus sint aut officiis.	\N	\N	\N	\N	t
1328	443	Episode 2 of Course 43	Non iure eos quaerat repudiandae rerum expedita. Enim nihil iste facere. Velit eaque expedita est numquam aspernatur.	\N	\N	\N	\N	f
1329	443	Episode 3 of Course 43	Saepe veritatis dolorem corporis laboriosam totam amet. Et temporibus placeat excepturi praesentium aut dicta cumque est. Sit voluptatum hic cumque et culpa.	\N	\N	\N	\N	f
1330	444	Episode 1 of Course 44	Occaecati nihil rerum saepe. Suscipit quibusdam nesciunt omnis placeat suscipit sit.	\N	\N	\N	\N	t
1331	444	Episode 2 of Course 44	Iure qui voluptas vitae dolor. Quae sit aperiam quis possimus dolorem perspiciatis dolor. Officia itaque eaque ipsum.	\N	\N	\N	\N	f
1332	444	Episode 3 of Course 44	Repellendus et fugiat ipsam modi consequatur consequatur. Rem eveniet quidem quod id. Tempora et repudiandae possimus maiores ab.	\N	\N	\N	\N	f
1333	445	Episode 1 of Course 45	Cupiditate dignissimos dicta et aut dolor. In eos vitae aut accusantium.	\N	\N	\N	\N	t
1334	445	Episode 2 of Course 45	Corrupti nulla repudiandae veniam deserunt. Harum quo nulla quam et ea. At minima cumque voluptatem qui.	\N	\N	\N	\N	f
1335	445	Episode 3 of Course 45	Debitis iusto velit omnis quia. Eligendi molestias tempore vitae vel modi. Nesciunt dolores voluptatibus atque nesciunt autem veniam sint.	\N	\N	\N	\N	f
1336	446	Episode 1 of Course 46	Qui eos et veritatis. Atque pariatur minima est neque veritatis eaque dolorem.	\N	\N	\N	\N	t
1337	446	Episode 2 of Course 46	Ut consequatur et reprehenderit temporibus animi molestias. Saepe totam iure vero. Consequuntur aut quisquam aliquid odio.	\N	\N	\N	\N	f
1338	446	Episode 3 of Course 46	Facilis voluptatem consequatur cumque voluptatem esse. Velit nihil atque veniam adipisci ut harum. Ut praesentium perferendis debitis molestiae quo qui.	\N	\N	\N	\N	f
1339	447	Episode 1 of Course 47	Et ut tempore soluta delectus atque et velit. Nemo accusantium rerum harum veritatis in doloremque.	\N	\N	\N	\N	t
1340	447	Episode 2 of Course 47	Quos et quasi dicta animi est molestiae quisquam. Voluptatem ut eveniet nobis eveniet ea. Quam ea fugit aut et numquam beatae.	\N	\N	\N	\N	f
1341	447	Episode 3 of Course 47	Reiciendis laudantium possimus dolorem et minima quis tenetur. Nobis aperiam odio itaque ex eveniet sequi dignissimos. Esse aut placeat omnis ullam.	\N	\N	\N	\N	f
1342	448	Episode 1 of Course 48	Eos est fuga debitis aut ut sit nulla modi. Pariatur sunt reprehenderit delectus reprehenderit repellat a.	\N	\N	\N	\N	t
1343	448	Episode 2 of Course 48	Distinctio eos blanditiis quaerat non fuga impedit quae. Facere nesciunt in unde optio praesentium. Itaque aut ab modi voluptas.	\N	\N	\N	\N	f
1344	448	Episode 3 of Course 48	Corrupti rerum adipisci ullam eligendi similique. Ut nemo magni in assumenda officia. Omnis qui velit non inventore ratione suscipit sint vitae.	\N	\N	\N	\N	f
1345	449	Episode 1 of Course 49	Est et nihil ex consectetur. Qui facilis a aliquid dolorem debitis laborum.	\N	\N	\N	\N	t
1346	449	Episode 2 of Course 49	Magni unde quis ea maiores. Deleniti dolores quo est tenetur quaerat amet et unde. Et voluptas eos nesciunt quas.	\N	\N	\N	\N	f
1347	449	Episode 3 of Course 49	Porro itaque enim ratione provident. Dignissimos temporibus quo nisi porro eligendi magnam. Voluptatum veritatis veniam perspiciatis minus odio quia.	\N	\N	\N	\N	f
1348	450	Episode 1 of Course 50	Perspiciatis accusantium est a quisquam. Omnis excepturi aut at iusto.	\N	\N	\N	\N	t
1349	450	Episode 2 of Course 50	In enim quia rerum alias. Non pariatur ea ut sunt. Nulla et perspiciatis tempora eos nostrum exercitationem error.	\N	\N	\N	\N	f
1350	450	Episode 3 of Course 50	Delectus et perferendis quas magni dignissimos officiis sapiente. Est qui eaque deserunt exercitationem consequuntur vitae eum doloribus. Optio ducimus rem aliquid.	\N	\N	\N	\N	f
1351	451	Episode 1 of Course 51	Assumenda aut odio exercitationem est earum. Culpa et et unde eum provident explicabo officia.	\N	\N	\N	\N	t
1352	451	Episode 2 of Course 51	Quis rerum est asperiores ut blanditiis aut itaque. Enim rerum totam ea iste. Doloremque eligendi dolores suscipit in earum perferendis id.	\N	\N	\N	\N	f
1353	451	Episode 3 of Course 51	Repudiandae molestias est repellendus et suscipit aut. Possimus et ipsum autem nam et explicabo deleniti repellendus. Exercitationem officia a dolorem ratione laborum harum et.	\N	\N	\N	\N	f
1354	452	Episode 1 of Course 52	Repudiandae dolores cum aperiam voluptatem. Rerum veritatis quis voluptatem.	\N	\N	\N	\N	t
1355	452	Episode 2 of Course 52	Eveniet minima culpa nam magni nobis magnam. Cupiditate iure dolore aperiam qui omnis. Distinctio consequatur sit quaerat a ut.	\N	\N	\N	\N	f
1356	452	Episode 3 of Course 52	Delectus vel quo inventore iure eos magnam consequatur. Error et rerum aut a deserunt reiciendis nesciunt beatae. Amet et repudiandae veniam iure.	\N	\N	\N	\N	f
1357	453	Episode 1 of Course 53	Sed dolorum suscipit porro ea. At quis aut accusantium est.	\N	\N	\N	\N	t
1358	453	Episode 2 of Course 53	Cumque delectus id laborum quos. Unde hic illum quasi. Nam perferendis repudiandae veritatis illo neque amet.	\N	\N	\N	\N	f
1359	453	Episode 3 of Course 53	Nam ut voluptas doloremque corporis ipsam. Est et similique voluptatem laboriosam molestiae. Iure veritatis laudantium voluptatem temporibus quod.	\N	\N	\N	\N	f
1360	454	Episode 1 of Course 54	Nam deleniti ipsa odit assumenda quaerat veritatis. Voluptate pariatur iusto omnis voluptatem.	\N	\N	\N	\N	t
1361	454	Episode 2 of Course 54	Voluptatum minus reprehenderit non est qui dignissimos facilis. Rerum itaque nam odit natus et error natus. Minus modi error adipisci saepe explicabo atque.	\N	\N	\N	\N	f
1362	454	Episode 3 of Course 54	Possimus libero minus neque omnis voluptatum blanditiis aperiam est. Aut reprehenderit fugiat nihil. Minus asperiores corrupti pariatur quisquam veritatis.	\N	\N	\N	\N	f
1363	455	Episode 1 of Course 55	Sed eum numquam magni. Esse non repellat excepturi.	\N	\N	\N	\N	t
1364	455	Episode 2 of Course 55	Sit corporis qui consequatur explicabo ea qui magni dicta. Incidunt minima corporis enim accusamus ducimus suscipit odit ea. Quasi et qui animi quod.	\N	\N	\N	\N	f
1365	455	Episode 3 of Course 55	Hic fuga eius dolorem nam. Eos quos velit ea ut eum optio. Rerum repudiandae possimus quia ex tenetur.	\N	\N	\N	\N	f
1366	456	Episode 1 of Course 56	Unde accusantium quasi sint consequuntur. Ducimus nemo omnis et facere.	\N	\N	\N	\N	t
1367	456	Episode 2 of Course 56	Rerum ut minus hic eum. Dolor autem sequi libero provident minus quia. Enim iste non nisi.	\N	\N	\N	\N	f
1368	456	Episode 3 of Course 56	Voluptatem occaecati dolorem consectetur qui sit quia. Esse incidunt quod rem exercitationem reiciendis aut. Neque maxime sed voluptas odio laborum delectus inventore.	\N	\N	\N	\N	f
1369	457	Episode 1 of Course 57	Magnam sapiente modi in. Totam ea qui dolore.	\N	\N	\N	\N	t
1370	457	Episode 2 of Course 57	Deleniti eum deserunt et odio. Eaque non enim soluta dolorem voluptatem. Voluptas provident saepe amet.	\N	\N	\N	\N	f
1371	457	Episode 3 of Course 57	Eos et et ducimus perferendis et. Aliquid ducimus suscipit ea cumque ut quas quia. Sequi quisquam architecto ut assumenda.	\N	\N	\N	\N	f
1372	458	Episode 1 of Course 58	In iusto eius illum. Nostrum sint alias pariatur.	\N	\N	\N	\N	t
1373	458	Episode 2 of Course 58	Doloribus rem blanditiis est quibusdam aperiam. Harum eum voluptatem cumque eligendi non placeat voluptate. Non inventore beatae enim eveniet.	\N	\N	\N	\N	f
1374	458	Episode 3 of Course 58	Praesentium non ducimus architecto aliquam. Laborum voluptas quia nihil ut facilis. Tenetur laborum rerum et nostrum laudantium nihil.	\N	\N	\N	\N	f
1375	459	Episode 1 of Course 59	Earum corporis inventore deleniti qui laudantium qui. Quam repellat aliquid et sint deserunt ut consequatur.	\N	\N	\N	\N	t
1376	459	Episode 2 of Course 59	Est maxime perspiciatis sed consequatur nihil. Laboriosam dolorem vel aliquam modi in perspiciatis et. Eveniet et aliquam dolorem aliquid.	\N	\N	\N	\N	f
1377	459	Episode 3 of Course 59	Esse natus delectus aut omnis dicta. Quia qui commodi et et dolorem. Nihil dolor adipisci consequatur reiciendis tempora sed voluptates.	\N	\N	\N	\N	f
1378	460	Episode 1 of Course 60	Ut sed libero voluptates eaque earum id similique. Enim quos aut voluptatem.	\N	\N	\N	\N	t
1379	460	Episode 2 of Course 60	Officiis eum inventore laborum natus quia molestiae. Similique sint similique reprehenderit dolore ut ratione voluptatibus. Odio vero ut quis et.	\N	\N	\N	\N	f
1380	460	Episode 3 of Course 60	Explicabo doloribus quisquam totam doloribus. Aut minima consequatur adipisci voluptatem. Et nulla sint nisi quia consequuntur sequi aliquid.	\N	\N	\N	\N	f
1381	461	Episode 1 of Course 61	Sit vel enim possimus nostrum ipsam. Itaque vero impedit tempora voluptas et corrupti repellendus.	\N	\N	\N	\N	t
1382	461	Episode 2 of Course 61	Expedita incidunt qui est numquam ratione officiis non ut. Architecto architecto ullam temporibus velit. Accusamus est et voluptas repellendus nostrum eius.	\N	\N	\N	\N	f
1383	461	Episode 3 of Course 61	Laboriosam voluptatem similique culpa sunt iusto. Harum vero quia dolores autem optio sunt est. Omnis qui ipsa ducimus cumque possimus labore possimus.	\N	\N	\N	\N	f
1384	462	Episode 1 of Course 62	Aliquam sit nostrum repellat eveniet. Doloribus molestiae consequatur officiis magni quisquam et ea.	\N	\N	\N	\N	t
1385	462	Episode 2 of Course 62	Dolores provident et veritatis aut explicabo aperiam necessitatibus. Perferendis sed sit doloremque aut. Aperiam sapiente et harum ducimus amet dolorem.	\N	\N	\N	\N	f
1386	462	Episode 3 of Course 62	Dolor assumenda similique rerum dolores quis alias. Totam sed est natus eligendi ut voluptas temporibus. Libero laborum soluta accusamus fuga voluptatum in dignissimos non.	\N	\N	\N	\N	f
1387	463	Episode 1 of Course 63	Sequi vel qui vel fugiat similique omnis laudantium. Est at aut dignissimos culpa quibusdam deserunt.	\N	\N	\N	\N	t
1388	463	Episode 2 of Course 63	Animi voluptatem incidunt sit animi aut. Dolore facere ut quibusdam nihil voluptas voluptas ea. Possimus sequi non dolore iste nostrum rem.	\N	\N	\N	\N	f
1389	463	Episode 3 of Course 63	Id non qui quas. Ea amet quod voluptatibus aut debitis. Asperiores dolores sint qui quasi.	\N	\N	\N	\N	f
1390	464	Episode 1 of Course 64	Esse qui labore voluptatem sint. Esse voluptates architecto unde ducimus impedit autem aut.	\N	\N	\N	\N	t
1391	464	Episode 2 of Course 64	Ad explicabo eos voluptas quasi deleniti. Repellat accusantium corrupti ducimus sit iste. Id aut fugit dicta porro.	\N	\N	\N	\N	f
1392	464	Episode 3 of Course 64	Voluptatibus sit voluptas minus est sunt accusamus doloremque. Sit ipsum eos non. Nam aut ipsa et nulla qui.	\N	\N	\N	\N	f
1393	465	Episode 1 of Course 65	Velit veniam sit dolorum ut debitis eum. Atque enim totam porro.	\N	\N	\N	\N	t
1394	465	Episode 2 of Course 65	Doloribus saepe molestias dolorem ipsum omnis eum et quis. Consequatur saepe ad ipsum sit. Excepturi itaque labore deleniti libero suscipit.	\N	\N	\N	\N	f
1395	465	Episode 3 of Course 65	Quaerat quisquam amet perspiciatis ratione aut laudantium consequatur similique. Sint qui in totam saepe voluptatem. Vitae commodi perspiciatis magni et voluptatem voluptatem omnis.	\N	\N	\N	\N	f
1396	466	Episode 1 of Course 66	Accusamus aut praesentium ut placeat. Qui consequuntur sint nesciunt minus quia accusantium.	\N	\N	\N	\N	t
1397	466	Episode 2 of Course 66	Nulla officia nihil rerum officia. Voluptatum maxime inventore laborum voluptatibus odit enim. Accusantium omnis rerum voluptatem qui quam qui.	\N	\N	\N	\N	f
1398	466	Episode 3 of Course 66	Quia iste alias dolor qui nihil et labore. Omnis aut fugit quis odio dolorem ullam nostrum eligendi. Omnis et rem consequatur in a inventore iure.	\N	\N	\N	\N	f
1399	467	Episode 1 of Course 67	Quo dolore minus ut laboriosam placeat. Sit vel facere enim alias similique nostrum.	\N	\N	\N	\N	t
1400	467	Episode 2 of Course 67	Libero fuga soluta id dolorem dignissimos earum autem. Quaerat sint nisi quaerat cumque. Ut magni ad similique est id voluptatem unde.	\N	\N	\N	\N	f
1401	467	Episode 3 of Course 67	Ea minima magni quibusdam autem ex. Omnis repellat voluptates voluptate sapiente voluptas ullam nisi. Sapiente optio veniam in corrupti reiciendis iure.	\N	\N	\N	\N	f
1402	468	Episode 1 of Course 68	Ut reiciendis aliquid quo. Voluptatem est iusto quas facere non odio praesentium.	\N	\N	\N	\N	t
1403	468	Episode 2 of Course 68	Quia excepturi dolorem eveniet a ab. Dolore ut at quis asperiores quia aliquam omnis. Explicabo dolorem quas placeat et quo reprehenderit.	\N	\N	\N	\N	f
1404	468	Episode 3 of Course 68	Sed sunt provident nihil quaerat rerum. Eligendi unde nostrum expedita sit eos temporibus. Amet sit quidem nobis blanditiis nostrum.	\N	\N	\N	\N	f
1405	469	Episode 1 of Course 69	Reiciendis ratione eveniet velit sapiente enim. Eum distinctio consequatur ipsam vero.	\N	\N	\N	\N	t
1406	469	Episode 2 of Course 69	Ullam fugiat pariatur est consequatur. In exercitationem laborum maiores facere. Expedita eveniet sint sint illo velit qui deserunt.	\N	\N	\N	\N	f
1407	469	Episode 3 of Course 69	Et libero eius reprehenderit a vitae sint mollitia. Optio accusamus doloribus aut sit culpa tenetur quasi iure. Minus sed laboriosam ut sunt omnis ut.	\N	\N	\N	\N	f
1408	470	Episode 1 of Course 70	Minus provident qui quae suscipit. Quam quo libero veritatis aut voluptas totam similique.	\N	\N	\N	\N	t
1409	470	Episode 2 of Course 70	Laudantium debitis quo architecto nemo placeat error excepturi et. Asperiores nihil eveniet velit. Delectus eligendi rem aut voluptatem qui quas dolorem velit.	\N	\N	\N	\N	f
1410	470	Episode 3 of Course 70	Nostrum eum voluptatem nulla dolor quas tenetur et. Possimus perspiciatis ut maiores. Alias commodi cumque occaecati tempore laborum et et illo.	\N	\N	\N	\N	f
1411	471	Episode 1 of Course 71	Sed et aliquid repudiandae hic debitis ipsam. Vel nemo qui magnam maiores quibusdam odit.	\N	\N	\N	\N	t
1412	471	Episode 2 of Course 71	Cumque error maxime repellendus nostrum. Corrupti omnis in sit quaerat laboriosam. Omnis distinctio ipsum eum ratione sint.	\N	\N	\N	\N	f
1413	471	Episode 3 of Course 71	Nemo dolor omnis quas dolor id minima officiis enim. Dolore saepe delectus rem dolorum. Quis eos doloribus nisi numquam voluptatem pariatur.	\N	\N	\N	\N	f
1414	472	Episode 1 of Course 72	Quos facilis quos alias atque. Et atque distinctio cumque sed.	\N	\N	\N	\N	t
1415	472	Episode 2 of Course 72	Deleniti sapiente est rerum iste et et sunt quisquam. Voluptatem dolores consequuntur tempora aut quos et distinctio ut. Occaecati necessitatibus dicta quod nemo.	\N	\N	\N	\N	f
1416	472	Episode 3 of Course 72	Expedita illum rerum voluptatem nesciunt veritatis odio distinctio. Id ullam aut eum aperiam qui voluptatem. Libero quidem iure dolorem velit nobis aut.	\N	\N	\N	\N	f
1417	473	Episode 1 of Course 73	Consequatur quaerat dolorem repellendus nihil doloribus totam ex. Similique soluta eum deserunt non dicta.	\N	\N	\N	\N	t
1418	473	Episode 2 of Course 73	Expedita nesciunt architecto consequatur aspernatur et dolorum doloremque delectus. Dolor fuga dolorem officiis dicta repellat ipsa sunt. Molestiae cupiditate est quasi minus veritatis ipsum.	\N	\N	\N	\N	f
1419	473	Episode 3 of Course 73	Quia et molestiae optio aliquid pariatur dolorum rerum. Accusamus sint non est sed officia non. Perspiciatis perferendis qui velit soluta voluptatibus voluptatum et.	\N	\N	\N	\N	f
1420	474	Episode 1 of Course 74	Temporibus laboriosam fugiat ducimus blanditiis sapiente placeat. Quaerat voluptatem a totam.	\N	\N	\N	\N	t
1421	474	Episode 2 of Course 74	Corrupti tempore modi consequatur cumque dolor est non. Non maxime nisi quasi atque tenetur nostrum. Molestiae ab id autem nam.	\N	\N	\N	\N	f
1422	474	Episode 3 of Course 74	Et explicabo accusamus beatae asperiores suscipit voluptas dolor. Et ipsam odit vero a fuga tenetur molestias iure. Quam consequatur repellendus quaerat itaque vitae totam nulla.	\N	\N	\N	\N	f
1423	475	Episode 1 of Course 75	Architecto nulla dolorum iusto et debitis. Temporibus aut cupiditate sequi culpa nulla.	\N	\N	\N	\N	t
1424	475	Episode 2 of Course 75	Dolores eligendi occaecati adipisci nihil sunt. Consectetur minima ad omnis libero in rerum officia. Quisquam dolore id quos nemo.	\N	\N	\N	\N	f
1425	475	Episode 3 of Course 75	Voluptatibus consectetur vel maiores ipsa. Id consequatur expedita atque et. Dolores voluptatem quasi amet.	\N	\N	\N	\N	f
1426	476	Episode 1 of Course 76	Quia omnis labore animi expedita sed illum labore. Sit deleniti voluptatem aut non non.	\N	\N	\N	\N	t
1427	476	Episode 2 of Course 76	Quam quibusdam quia sint optio adipisci culpa consectetur. Repellendus est illo autem assumenda nesciunt similique et. Voluptas quis molestias illum qui sit omnis.	\N	\N	\N	\N	f
1428	476	Episode 3 of Course 76	Ea beatae voluptas hic harum facere. Est qui voluptatem perspiciatis quo. Ratione rem dicta id ut.	\N	\N	\N	\N	f
1429	477	Episode 1 of Course 77	Voluptas molestiae in non esse magnam. Accusantium temporibus consectetur hic aut sed.	\N	\N	\N	\N	t
1430	477	Episode 2 of Course 77	Fugiat dolorem cumque magnam suscipit cupiditate in. Non voluptatem cumque et. Rerum est praesentium officiis natus id.	\N	\N	\N	\N	f
1431	477	Episode 3 of Course 77	Est ut numquam dolor est tenetur beatae. Aspernatur earum et dolorum beatae amet. At numquam rem non dicta non.	\N	\N	\N	\N	f
1432	478	Episode 1 of Course 78	Cumque pariatur provident nobis porro dignissimos repudiandae voluptatem. Illo ea aspernatur deserunt eligendi laboriosam repellendus.	\N	\N	\N	\N	t
1433	478	Episode 2 of Course 78	Eaque iste voluptatibus quis. Repellat rerum consequatur quibusdam architecto et. Non repudiandae corporis molestiae at.	\N	\N	\N	\N	f
1434	478	Episode 3 of Course 78	Et magni quod sint nam. Laborum iusto dicta aut et et ad. Enim temporibus quibusdam et modi.	\N	\N	\N	\N	f
1435	479	Episode 1 of Course 79	Occaecati rerum ut voluptatem perspiciatis nesciunt. Saepe pariatur sequi tempore architecto sunt.	\N	\N	\N	\N	t
1436	479	Episode 2 of Course 79	Ex aut accusamus nam autem mollitia. Quia nostrum illum illo suscipit. Quia esse modi omnis et est nesciunt dolores.	\N	\N	\N	\N	f
1437	479	Episode 3 of Course 79	Magni corrupti quibusdam velit et. Hic at assumenda sequi ad corrupti. Ullam ratione veniam vel placeat pariatur incidunt quia.	\N	\N	\N	\N	f
1438	480	Episode 1 of Course 80	Id quam praesentium quia enim sit. Officiis ea ducimus alias in.	\N	\N	\N	\N	t
1439	480	Episode 2 of Course 80	Totam facilis quia aut itaque vel. Praesentium inventore aut mollitia rerum. Aspernatur placeat cupiditate quas atque.	\N	\N	\N	\N	f
1440	480	Episode 3 of Course 80	Qui doloribus id omnis distinctio. Quibusdam ducimus ad nihil ullam. Voluptatem aut error ea et.	\N	\N	\N	\N	f
1441	481	Episode 1 of Course 81	Tempora adipisci incidunt ullam deserunt vel ea. Autem ut rerum minima ipsam voluptatem consequatur nostrum.	\N	\N	\N	\N	t
1442	481	Episode 2 of Course 81	Optio ipsa voluptatem assumenda aliquam. Quo consequuntur iure consequatur. Incidunt cum impedit qui rerum placeat eos autem omnis.	\N	\N	\N	\N	f
1443	481	Episode 3 of Course 81	Quo sed sunt tempore repellendus. Ea aliquid voluptatem quis quia nihil cum. Ea facilis autem repudiandae magni.	\N	\N	\N	\N	f
1444	482	Episode 1 of Course 82	Et eaque quia minima dicta. Inventore eum ea expedita aut in ab.	\N	\N	\N	\N	t
1445	482	Episode 2 of Course 82	Tenetur quis nemo saepe fuga rerum. At incidunt perferendis error enim facilis. Vitae molestiae iusto ullam ad quaerat ad dicta quibusdam.	\N	\N	\N	\N	f
1446	482	Episode 3 of Course 82	Est soluta saepe pariatur repudiandae dignissimos illum. Dolorum qui veniam consequuntur ratione. Modi dolorum veritatis qui.	\N	\N	\N	\N	f
1447	483	Episode 1 of Course 83	Placeat aut aspernatur officia sint odio id reiciendis omnis. Aut a et a aut voluptas et.	\N	\N	\N	\N	t
1448	483	Episode 2 of Course 83	Mollitia eaque nulla quia nisi quod doloribus. Aut aut necessitatibus blanditiis doloribus. Rerum reprehenderit repudiandae et vel aspernatur non quisquam.	\N	\N	\N	\N	f
1449	483	Episode 3 of Course 83	Et minus architecto doloribus eligendi possimus praesentium et. Laudantium recusandae non provident nihil. Repellat ut harum voluptatibus dolores consequatur.	\N	\N	\N	\N	f
1450	484	Episode 1 of Course 84	Rerum est tenetur aliquam doloremque. Sed dolorem officia velit sit totam blanditiis.	\N	\N	\N	\N	t
1451	484	Episode 2 of Course 84	Mollitia quisquam officiis distinctio ut impedit. Eveniet laboriosam sequi inventore aperiam. Qui nesciunt cupiditate ea et et possimus illo.	\N	\N	\N	\N	f
1452	484	Episode 3 of Course 84	Fugit iure ratione rerum maxime. Minima nemo laboriosam cum voluptatem dolor. Excepturi ipsam ducimus eum error adipisci.	\N	\N	\N	\N	f
1453	485	Episode 1 of Course 85	Perferendis laudantium fugiat vero aut qui. Voluptatem vitae ea ut iusto sapiente optio.	\N	\N	\N	\N	t
1454	485	Episode 2 of Course 85	Consequatur qui at est. Et fuga harum aut repellat pariatur voluptatem. Corporis qui enim non velit.	\N	\N	\N	\N	f
1455	485	Episode 3 of Course 85	Aperiam illum laboriosam eaque ipsam accusamus deserunt. Cupiditate velit tempore tempora error commodi eveniet nesciunt. Earum distinctio consequatur quaerat praesentium nulla nostrum debitis.	\N	\N	\N	\N	f
1456	486	Episode 1 of Course 86	Qui magni fugiat eos a qui. Non et quibusdam sed velit est quis.	\N	\N	\N	\N	t
1457	486	Episode 2 of Course 86	Veritatis enim eveniet nesciunt velit. Est qui aperiam adipisci nisi. Non corporis enim corporis ut qui excepturi dolorum.	\N	\N	\N	\N	f
1458	486	Episode 3 of Course 86	Illum aut qui esse architecto perferendis. Vero tempora iusto optio veritatis. Et iure enim ut ut fuga veniam.	\N	\N	\N	\N	f
1459	487	Episode 1 of Course 87	Placeat sed repellat qui possimus. Expedita culpa quia qui.	\N	\N	\N	\N	t
1460	487	Episode 2 of Course 87	Iure perferendis cumque laborum. Sequi quisquam numquam optio ut voluptas. Illum quas possimus et dolores aut id excepturi.	\N	\N	\N	\N	f
1461	487	Episode 3 of Course 87	Incidunt rem id quaerat sed tempore iste autem. Animi nesciunt reprehenderit maxime eos est illum qui. At neque tempora et laboriosam necessitatibus facere quod.	\N	\N	\N	\N	f
1462	488	Episode 1 of Course 88	Aut est veniam aut est doloribus voluptas laborum. Aut hic maiores nemo occaecati dolorum delectus nostrum.	\N	\N	\N	\N	t
1463	488	Episode 2 of Course 88	Qui deserunt animi impedit quam voluptatem. Molestias enim doloribus repellat velit quos soluta. Veniam non quis et.	\N	\N	\N	\N	f
1464	488	Episode 3 of Course 88	Praesentium ut ea temporibus qui dignissimos maxime. Reiciendis rerum distinctio dolores at aliquid non. Fugiat sequi libero et et itaque aut omnis et.	\N	\N	\N	\N	f
1465	489	Episode 1 of Course 89	Nisi ipsum eligendi est eveniet possimus est. Optio id voluptas ipsa perspiciatis numquam repellendus exercitationem.	\N	\N	\N	\N	t
1466	489	Episode 2 of Course 89	Numquam non omnis ab nemo aut nihil. Repellat perspiciatis animi dolor ullam. Ut at officiis et accusamus consequuntur aliquid ducimus alias.	\N	\N	\N	\N	f
1467	489	Episode 3 of Course 89	Omnis quia sint quisquam nisi sint. Quam quis cumque magnam consectetur illo optio nihil. Quis sunt neque aut et.	\N	\N	\N	\N	f
1468	490	Episode 1 of Course 90	Rerum voluptas quos iure. Earum dolores possimus corrupti fugiat alias suscipit.	\N	\N	\N	\N	t
1469	490	Episode 2 of Course 90	Itaque et nisi voluptatum et. Qui animi assumenda qui et et voluptatem neque et. Ut et aut esse ea consectetur.	\N	\N	\N	\N	f
1470	490	Episode 3 of Course 90	Consequatur et occaecati voluptatem quos voluptatum et temporibus. Quis assumenda fugiat iste error dolorem. Ut cumque et voluptatem error est.	\N	\N	\N	\N	f
1471	491	Episode 1 of Course 91	Debitis rerum esse aliquid sequi expedita excepturi. Enim excepturi quam aspernatur quisquam aut eos illum.	\N	\N	\N	\N	t
1472	491	Episode 2 of Course 91	Sed quod dolore enim quia doloribus quae autem enim. Qui ut ut enim eos dolor aperiam maiores. Quidem officiis quibusdam perferendis iste in ipsam enim.	\N	\N	\N	\N	f
1473	491	Episode 3 of Course 91	Rem voluptas id magni quas sunt. Eum nam rerum itaque quasi doloremque. Ratione dolores fugiat ea libero consequatur sed.	\N	\N	\N	\N	f
1474	492	Episode 1 of Course 92	Nihil non explicabo sed aut. Similique placeat quas reprehenderit corporis.	\N	\N	\N	\N	t
1475	492	Episode 2 of Course 92	Aut eum nobis rerum eum. Dolorem quo non aspernatur et provident. Accusantium consequuntur voluptatem aut qui et laborum repellendus dolorem.	\N	\N	\N	\N	f
1476	492	Episode 3 of Course 92	Ducimus ratione perferendis et minus repellat repellendus. Aliquid voluptatem voluptatem ab incidunt consequatur. Quo et magni eum unde.	\N	\N	\N	\N	f
1477	493	Episode 1 of Course 93	Quasi voluptate culpa voluptatem. Et assumenda est eius maiores nostrum.	\N	\N	\N	\N	t
1478	493	Episode 2 of Course 93	Consectetur et earum et quia enim rem. Ipsam delectus ducimus ea ducimus accusamus. Cum illum eaque unde quae ab aperiam.	\N	\N	\N	\N	f
1479	493	Episode 3 of Course 93	Dolorem culpa eveniet harum ab quis et. Tempora saepe aut laudantium atque atque quo. Molestias quia quos nam autem dolores itaque reiciendis.	\N	\N	\N	\N	f
1480	494	Episode 1 of Course 94	Illum iste doloribus et reprehenderit officiis fuga ut. Labore dolor consequatur rerum quo molestiae ut.	\N	\N	\N	\N	t
1481	494	Episode 2 of Course 94	Cum suscipit inventore deserunt amet nihil. Sunt ut atque magnam et est. Et inventore in possimus eos nemo quas qui.	\N	\N	\N	\N	f
1482	494	Episode 3 of Course 94	Maiores laboriosam velit consequatur. Minus cum necessitatibus neque aperiam id esse quis. Qui explicabo commodi perspiciatis facilis.	\N	\N	\N	\N	f
1483	495	Episode 1 of Course 95	Rerum atque aperiam asperiores quisquam perferendis. Velit explicabo ut eum voluptatum qui.	\N	\N	\N	\N	t
1484	495	Episode 2 of Course 95	Eaque non corporis et voluptas autem esse. Suscipit atque alias consequatur ipsam ea animi repellat. Qui ut vitae atque quia.	\N	\N	\N	\N	f
1485	495	Episode 3 of Course 95	Autem vel ex possimus velit quo eaque. Commodi numquam quas et ipsum sed. Repellendus facere suscipit quibusdam.	\N	\N	\N	\N	f
1486	496	Episode 1 of Course 96	Unde incidunt dicta qui sit quae architecto quasi. Ut officiis et aliquam aut omnis a.	\N	\N	\N	\N	t
1487	496	Episode 2 of Course 96	Sed ullam cupiditate minus impedit ut. Architecto ab earum enim possimus. Odio deleniti est vitae.	\N	\N	\N	\N	f
1488	496	Episode 3 of Course 96	Suscipit sed voluptatem sit voluptas laudantium vel nihil. Ut modi ea odio. Ratione dignissimos similique sint vitae quia quos.	\N	\N	\N	\N	f
1489	497	Episode 1 of Course 97	Eum explicabo quaerat maiores voluptatibus dolor voluptatibus ea sed. Occaecati labore ut ab placeat tempore nesciunt.	\N	\N	\N	\N	t
1490	497	Episode 2 of Course 97	Nostrum facere est ea eum. Eum est dignissimos ullam alias autem iure vel. Ut totam sapiente cumque.	\N	\N	\N	\N	f
1491	497	Episode 3 of Course 97	Perferendis id molestias animi eos. Eos vel explicabo qui nam voluptas. Nobis officiis aliquam inventore.	\N	\N	\N	\N	f
1492	498	Episode 1 of Course 98	Illum velit consequatur illum dolore voluptatem soluta. Vel quam rerum doloribus velit quod esse neque.	\N	\N	\N	\N	t
1493	498	Episode 2 of Course 98	Consequuntur atque magni harum eligendi nobis necessitatibus. Molestiae ut beatae nihil rem veniam. Possimus dolores quae aliquid.	\N	\N	\N	\N	f
1494	498	Episode 3 of Course 98	Ex fugit praesentium et minima voluptas mollitia qui. Non dolorem dolorem aperiam molestiae libero. Sint cum sed quia ut nisi sit eum.	\N	\N	\N	\N	f
1495	499	Episode 1 of Course 99	Mollitia ut non beatae quia aperiam dolorem sit et. Reprehenderit non ex consequatur optio porro.	\N	\N	\N	\N	t
1496	499	Episode 2 of Course 99	Soluta unde asperiores sit doloremque. In non est repellat temporibus. Tenetur suscipit non quibusdam maiores aliquam saepe officia.	\N	\N	\N	\N	f
1497	499	Episode 3 of Course 99	Repudiandae voluptas inventore adipisci maiores impedit atque sit. In quis est et dolor enim. Nemo eum et eaque nostrum error.	\N	\N	\N	\N	f
1498	500	Episode 1 of Course 100	Autem odit ut ducimus inventore perferendis corrupti sunt ad. Iure ratione maxime voluptatum delectus in.	\N	\N	\N	\N	t
1499	500	Episode 2 of Course 100	Rerum minima ut molestias inventore sit eligendi sed. Sunt commodi voluptas porro repellendus et sed. Sit enim voluptatem ut accusamus aspernatur qui explicabo.	\N	\N	\N	\N	f
1500	500	Episode 3 of Course 100	Inventore est animi et eius ea qui earum at. Consectetur autem est iusto enim. Est in facere quasi veniam voluptas laudantium.	\N	\N	\N	\N	f
\.


--
-- TOC entry 4941 (class 0 OID 16722)
-- Dependencies: 233
-- Data for Name: episode_draft; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.episode_draft (id, chapter_draft_id, name, description, video_path, image_path, public_image_id, public_video_id, is_free_to_watch) FROM stdin;
1201	401	Episode 1 of Course 1	Maiores doloribus repudiandae est voluptate vitae laudantium. Et occaecati voluptatem ea ab eos.	\N	\N	\N	\N	t
1202	401	Episode 2 of Course 1	Laudantium temporibus recusandae placeat voluptas suscipit eaque omnis. Voluptatum corrupti aperiam non voluptatem inventore qui totam. Nemo ex quo molestiae facere eaque ut.	\N	\N	\N	\N	f
1203	401	Episode 3 of Course 1	A temporibus eum ducimus adipisci amet amet. Expedita est fugit voluptatem nisi iusto inventore qui. Dolorem explicabo explicabo aut voluptatibus inventore dolores.	\N	\N	\N	\N	f
1204	402	Episode 1 of Course 2	Odio occaecati earum ipsam libero. Blanditiis ut commodi velit dicta in.	\N	\N	\N	\N	t
1205	402	Episode 2 of Course 2	Aliquid ad quia natus consequatur. Sequi aut nobis voluptas quisquam voluptatum cupiditate pariatur. Deleniti eos tempore voluptas et praesentium ullam aspernatur.	\N	\N	\N	\N	f
1206	402	Episode 3 of Course 2	Impedit placeat magnam voluptates sunt quibusdam harum. Perspiciatis itaque asperiores illo omnis. Provident voluptatum voluptatem eius natus impedit aut.	\N	\N	\N	\N	f
1207	403	Episode 1 of Course 3	Voluptas expedita explicabo ut tempore temporibus iste. Perferendis et modi qui nemo fugit alias cupiditate perferendis.	\N	\N	\N	\N	t
1208	403	Episode 2 of Course 3	Eligendi mollitia consequatur laboriosam aut fugit expedita est. Non et ut vel mollitia et. Sed et qui unde incidunt.	\N	\N	\N	\N	f
1209	403	Episode 3 of Course 3	Iusto dolores est et exercitationem. Voluptatem nam quia et porro. Mollitia provident nam ipsa adipisci illum.	\N	\N	\N	\N	f
1210	404	Episode 1 of Course 4	Hic et corporis porro neque aspernatur quod. Praesentium nihil iure aut et rerum dolores corrupti ut.	\N	\N	\N	\N	t
1211	404	Episode 2 of Course 4	Doloribus iure error occaecati sit praesentium alias veniam. Placeat vel ducimus dolorem iusto non sunt commodi. Vel dolores reiciendis repudiandae deleniti voluptatem saepe et.	\N	\N	\N	\N	f
1212	404	Episode 3 of Course 4	Alias et ipsam dicta ut et et. Aperiam nobis et iure. Odio similique animi nostrum repellat itaque voluptatem quia.	\N	\N	\N	\N	f
1213	405	Episode 1 of Course 5	Libero illo et quam illum. Aliquam quia accusantium quis debitis.	\N	\N	\N	\N	t
1214	405	Episode 2 of Course 5	Aperiam necessitatibus fugit ex eaque. Nihil voluptatum ut non. Ut optio quis delectus quos quia quis placeat doloremque.	\N	\N	\N	\N	f
1215	405	Episode 3 of Course 5	Iste commodi ipsa aut voluptatibus. Qui molestiae voluptas nihil consectetur similique voluptas. Esse reprehenderit qui inventore sapiente omnis.	\N	\N	\N	\N	f
1216	406	Episode 1 of Course 6	Molestiae eaque et suscipit ipsam quam neque et. Et laboriosam dolorem minus adipisci.	\N	\N	\N	\N	t
1217	406	Episode 2 of Course 6	Vel reiciendis veritatis architecto rem debitis est molestiae. Quae molestias ad non fugit aperiam. Ut tenetur pariatur quo.	\N	\N	\N	\N	f
1218	406	Episode 3 of Course 6	Amet libero placeat voluptas nemo. Vero ut temporibus quis eius soluta commodi. Deleniti doloremque sapiente neque vero aut aut ut.	\N	\N	\N	\N	f
1219	407	Episode 1 of Course 7	Rerum itaque pariatur deserunt. Qui vel voluptas qui est.	\N	\N	\N	\N	t
1220	407	Episode 2 of Course 7	Explicabo velit in dolores eveniet eius voluptas voluptatem eos. Quibusdam quia mollitia cupiditate magnam ea dignissimos facilis. In debitis consectetur debitis quia explicabo facilis et quibusdam.	\N	\N	\N	\N	f
1221	407	Episode 3 of Course 7	Qui eveniet perspiciatis hic blanditiis mollitia eos. Amet expedita voluptate et amet enim quibusdam ea. Illo et voluptatem voluptatum eius totam sit.	\N	\N	\N	\N	f
1222	408	Episode 1 of Course 8	Est deserunt nobis aut laboriosam. Ut et voluptatibus tenetur dignissimos sequi qui nulla.	\N	\N	\N	\N	t
1223	408	Episode 2 of Course 8	Iste quis labore necessitatibus placeat fugiat illum. Tenetur inventore cupiditate dolorem. Laborum sed est dolorem blanditiis inventore libero numquam unde.	\N	\N	\N	\N	f
1224	408	Episode 3 of Course 8	Ea aut officia nulla rem ipsa pariatur neque. Velit quisquam tenetur voluptate voluptatibus molestiae dicta nemo. Consequatur quidem est dolor quia temporibus ut facilis.	\N	\N	\N	\N	f
1225	409	Episode 1 of Course 9	Ducimus ratione quia earum distinctio. Minus fugiat voluptas suscipit minima labore nihil.	\N	\N	\N	\N	t
1226	409	Episode 2 of Course 9	In voluptate nisi reiciendis hic nulla iusto. Perferendis ut voluptatem delectus fugiat aliquam. In eos eum illo rerum et.	\N	\N	\N	\N	f
1227	409	Episode 3 of Course 9	Voluptatibus quisquam vitae commodi. Quas et quis debitis error quos et. Culpa et fuga doloremque et asperiores.	\N	\N	\N	\N	f
1228	410	Episode 1 of Course 10	Et laboriosam non nesciunt doloremque. Minima quia quia cumque labore quis ut.	\N	\N	\N	\N	t
1229	410	Episode 2 of Course 10	Maiores quos minima eveniet officiis incidunt. Rerum et animi et dignissimos labore exercitationem. Et dolores deserunt accusamus debitis.	\N	\N	\N	\N	f
1230	410	Episode 3 of Course 10	Nisi ullam a aperiam incidunt quibusdam. A quia praesentium qui nisi incidunt. Neque porro esse sequi aliquid dolor esse.	\N	\N	\N	\N	f
1231	411	Episode 1 of Course 11	Quisquam minus similique et reiciendis. Explicabo ipsum qui sed impedit natus possimus provident.	\N	\N	\N	\N	t
1232	411	Episode 2 of Course 11	Quod cumque velit libero earum voluptatem qui. Eum consectetur voluptate dolores accusantium. Odio delectus maiores qui exercitationem laudantium beatae.	\N	\N	\N	\N	f
1233	411	Episode 3 of Course 11	Perferendis eius deserunt veniam laboriosam sit quod et hic. Officia sit commodi mollitia aperiam. Laboriosam distinctio molestiae perspiciatis porro quos recusandae.	\N	\N	\N	\N	f
1234	412	Episode 1 of Course 12	Odio dolores inventore dolor saepe quaerat. Consequatur saepe exercitationem qui.	\N	\N	\N	\N	t
1235	412	Episode 2 of Course 12	Tempora atque ullam unde perferendis voluptas aut. Voluptas eum vero rerum ipsum assumenda eveniet eligendi. Id dolores rerum eaque laudantium est.	\N	\N	\N	\N	f
1236	412	Episode 3 of Course 12	Occaecati nulla necessitatibus sint. Et officia perspiciatis hic voluptates doloremque incidunt eius voluptate. Nihil magni consequatur aut ducimus nostrum.	\N	\N	\N	\N	f
1237	413	Episode 1 of Course 13	Et aut non et rerum. Voluptate explicabo repellat suscipit labore commodi asperiores et quod.	\N	\N	\N	\N	t
1238	413	Episode 2 of Course 13	Rerum nam consequatur iure eius. Sit qui labore blanditiis veniam et earum sapiente sint. Nostrum ea explicabo aut architecto ratione et.	\N	\N	\N	\N	f
1239	413	Episode 3 of Course 13	Odit natus qui iste error est voluptas. Facilis aut reprehenderit vitae molestiae quaerat corrupti. Expedita repellendus ut perspiciatis et.	\N	\N	\N	\N	f
1240	414	Episode 1 of Course 14	Rerum distinctio est necessitatibus quisquam rerum est. Perferendis nulla provident occaecati sit ab.	\N	\N	\N	\N	t
1241	414	Episode 2 of Course 14	Officiis quisquam voluptate repellendus autem aliquam. Quo qui soluta dolore. Alias optio qui occaecati recusandae quia molestiae.	\N	\N	\N	\N	f
1242	414	Episode 3 of Course 14	Qui placeat delectus eius est excepturi quia. Repellendus ut maxime facere deserunt deleniti. Excepturi a consequatur nesciunt rerum occaecati sit perspiciatis.	\N	\N	\N	\N	f
1243	415	Episode 1 of Course 15	Enim dolor voluptatem sed in qui est. Expedita odio sed deleniti dolores.	\N	\N	\N	\N	t
1244	415	Episode 2 of Course 15	At libero quos debitis autem voluptas quis. Harum occaecati in maiores veniam rerum dolorem maiores. Repellendus maxime et ipsa eum libero.	\N	\N	\N	\N	f
1245	415	Episode 3 of Course 15	Aut tenetur minus quae dolorem quo harum qui. Impedit ipsam nostrum et fuga molestiae quaerat. Ipsum nesciunt tenetur esse id magnam omnis aut nostrum.	\N	\N	\N	\N	f
1246	416	Episode 1 of Course 16	Dolores impedit quidem ipsam sapiente et. Debitis fugiat maxime quo et sed.	\N	\N	\N	\N	t
1247	416	Episode 2 of Course 16	Tenetur deleniti maiores nemo. Qui vel consequuntur et dolores inventore fuga soluta corrupti. Optio expedita ad est aliquid.	\N	\N	\N	\N	f
1248	416	Episode 3 of Course 16	Quisquam molestiae esse totam ipsam est doloribus. Facilis vitae eum voluptas magni aut corrupti. Atque dolorum aspernatur mollitia autem perferendis id.	\N	\N	\N	\N	f
1249	417	Episode 1 of Course 17	Iure consectetur vel dolor veritatis unde. Numquam ut dolore autem aut.	\N	\N	\N	\N	t
1250	417	Episode 2 of Course 17	Qui voluptatum hic nesciunt magnam aliquam impedit. Non odit error quis nostrum. Ut vero voluptate explicabo suscipit a dolorem.	\N	\N	\N	\N	f
1251	417	Episode 3 of Course 17	Voluptatem dolorem quae molestiae eligendi et quia. Et et qui fugiat quod ducimus voluptas odit. Animi dicta amet vel iusto similique quia.	\N	\N	\N	\N	f
1252	418	Episode 1 of Course 18	Est minus beatae architecto quos velit. Et veniam voluptate necessitatibus suscipit.	\N	\N	\N	\N	t
1253	418	Episode 2 of Course 18	Illo facere fuga placeat qui adipisci asperiores consequuntur. Rerum nesciunt est ut dolores impedit. Et perspiciatis fugit reprehenderit amet minima ea dicta.	\N	\N	\N	\N	f
1254	418	Episode 3 of Course 18	Nihil blanditiis fugit ut exercitationem fugiat quod culpa. Dolore inventore voluptatem quo vel aut. Voluptas nihil voluptates cumque assumenda.	\N	\N	\N	\N	f
1255	419	Episode 1 of Course 19	Cupiditate commodi atque non. Voluptatibus fugit ad in ratione ut culpa expedita.	\N	\N	\N	\N	t
1256	419	Episode 2 of Course 19	Enim cum repellendus molestiae vitae praesentium. Maxime doloremque facilis esse quo voluptas eveniet ratione. Accusamus distinctio nulla laborum.	\N	\N	\N	\N	f
1257	419	Episode 3 of Course 19	Molestiae saepe ut ut unde. Et ad voluptatum modi et odit. Nihil ea iusto est.	\N	\N	\N	\N	f
1258	420	Episode 1 of Course 20	Ipsam quis molestias aut est. Autem nemo aliquid enim praesentium sunt.	\N	\N	\N	\N	t
1259	420	Episode 2 of Course 20	Praesentium corrupti reprehenderit ut odit aperiam. Velit distinctio sed quam earum provident reiciendis eos. Impedit ea et optio et omnis accusamus rerum.	\N	\N	\N	\N	f
1260	420	Episode 3 of Course 20	Porro nostrum adipisci ipsam est. Facere nostrum repudiandae saepe corporis. Natus odio consequuntur eius in similique in.	\N	\N	\N	\N	f
1261	421	Episode 1 of Course 21	Ipsam enim provident quibusdam. Dolorem ratione voluptatem beatae iste.	\N	\N	\N	\N	t
1262	421	Episode 2 of Course 21	Fuga et deserunt et assumenda veniam. Voluptatibus odio atque eos minus. Error ea in iste.	\N	\N	\N	\N	f
1263	421	Episode 3 of Course 21	Qui labore aut omnis ea nulla. Dolorem provident maxime saepe ea. Voluptatibus alias sint reiciendis voluptates dolores ut.	\N	\N	\N	\N	f
1264	422	Episode 1 of Course 22	Qui sint voluptas neque sed voluptates porro nam incidunt. Ducimus sapiente animi enim.	\N	\N	\N	\N	t
1265	422	Episode 2 of Course 22	Quia quo vero fugit expedita. Commodi natus minima sed nesciunt. Qui eius ipsa quidem sunt.	\N	\N	\N	\N	f
1266	422	Episode 3 of Course 22	Omnis voluptas repudiandae dolor quod. Fugit ipsam aut nisi dolorem corrupti illo dolorem qui. Quam natus atque nam aspernatur dolores.	\N	\N	\N	\N	f
1267	423	Episode 1 of Course 23	Molestias et sunt aut enim. Aliquam quia vel iure voluptatem.	\N	\N	\N	\N	t
1268	423	Episode 2 of Course 23	Autem quasi odio fuga. Earum rerum aut quo assumenda illo fuga suscipit. Necessitatibus aut sed voluptatem quasi dignissimos quibusdam.	\N	\N	\N	\N	f
1269	423	Episode 3 of Course 23	Voluptate aperiam nulla sint ipsa ut sunt vero. Iste repellat iusto voluptates adipisci. Et quia aut quam eum qui est.	\N	\N	\N	\N	f
1270	424	Episode 1 of Course 24	Quo fugiat quo dolores ipsam eaque. Ab reiciendis autem saepe in placeat.	\N	\N	\N	\N	t
1271	424	Episode 2 of Course 24	Architecto velit ratione eveniet aut laborum rerum repellendus. Eum officiis maiores dolorem error et. Eum maxime cumque similique optio in id.	\N	\N	\N	\N	f
1272	424	Episode 3 of Course 24	Quod officiis et doloremque minus. Est quidem laudantium dicta quia quam dolorem. Labore illum incidunt eum sunt rerum.	\N	\N	\N	\N	f
1273	425	Episode 1 of Course 25	Ut asperiores aliquid eum omnis deleniti. Aut necessitatibus fugiat enim nostrum enim libero et.	\N	\N	\N	\N	t
1274	425	Episode 2 of Course 25	Et et illo iste dolores. Impedit quo temporibus saepe. Ad error quam consequatur.	\N	\N	\N	\N	f
1275	425	Episode 3 of Course 25	Officia mollitia labore deleniti libero qui accusamus assumenda. Et eum officia non et sint incidunt omnis. Voluptatum earum eius consectetur perspiciatis pariatur alias tenetur et.	\N	\N	\N	\N	f
1276	426	Episode 1 of Course 26	Illo dolores ut autem. Ea saepe ut sit accusantium recusandae.	\N	\N	\N	\N	t
1277	426	Episode 2 of Course 26	Dolorum accusamus quos nihil non. Voluptatem est dolorum laborum recusandae ducimus minus atque hic. Velit eaque magni rem aliquid.	\N	\N	\N	\N	f
1278	426	Episode 3 of Course 26	Repellendus quasi et et nemo quasi dolores. Autem saepe officia molestias consequuntur facere asperiores dolor. Dolores mollitia exercitationem alias et nulla sunt error.	\N	\N	\N	\N	f
1279	427	Episode 1 of Course 27	Non autem occaecati doloribus dolorem. Quia quibusdam ad alias id maiores consequatur dolorem.	\N	\N	\N	\N	t
1280	427	Episode 2 of Course 27	Eos in in itaque eum quos officia. Aspernatur nulla tempore eos eos atque quia rerum. Facilis eligendi sunt asperiores reprehenderit nihil possimus.	\N	\N	\N	\N	f
1281	427	Episode 3 of Course 27	Dolores beatae ratione ut voluptas in. Cumque et vitae fugit id ratione consectetur harum. Quidem qui soluta soluta minima vel in.	\N	\N	\N	\N	f
1282	428	Episode 1 of Course 28	Nostrum voluptatem consectetur odio recusandae ea eveniet. Qui voluptatibus aut est omnis enim voluptas nostrum similique.	\N	\N	\N	\N	t
1283	428	Episode 2 of Course 28	Doloremque commodi voluptas sunt sit molestiae. Voluptas deleniti omnis qui nisi. Et vero dignissimos rerum nostrum non.	\N	\N	\N	\N	f
1284	428	Episode 3 of Course 28	Sint et veniam placeat vitae et sunt. Perferendis tempora laboriosam impedit ut commodi aliquid nam. Doloribus accusamus quasi optio.	\N	\N	\N	\N	f
1285	429	Episode 1 of Course 29	Consequatur suscipit accusantium natus beatae autem. Quo voluptatem amet saepe.	\N	\N	\N	\N	t
1286	429	Episode 2 of Course 29	Veniam animi voluptas ut nihil fugiat officiis sint iusto. Illum rem non velit. Sapiente consectetur reiciendis aut officia voluptas non quia.	\N	\N	\N	\N	f
1287	429	Episode 3 of Course 29	Deleniti porro saepe placeat laboriosam minus deleniti accusamus. Consequuntur nobis sint doloribus. Corrupti iusto officia suscipit unde iure sequi eum.	\N	\N	\N	\N	f
1288	430	Episode 1 of Course 30	Et libero voluptate quo aut culpa iusto numquam quia. Reiciendis placeat officia doloremque et illum assumenda.	\N	\N	\N	\N	t
1289	430	Episode 2 of Course 30	Voluptatem itaque minus dolore non. Ducimus et quis aperiam harum corporis necessitatibus. Sunt cum modi consequatur.	\N	\N	\N	\N	f
1290	430	Episode 3 of Course 30	Maxime doloremque quaerat voluptates rerum ipsum veritatis. Dolor illum sed impedit assumenda. Accusantium reiciendis ut sequi.	\N	\N	\N	\N	f
1291	431	Episode 1 of Course 31	Aut voluptatum et ipsam velit itaque repellat. Officia porro et optio quo.	\N	\N	\N	\N	t
1292	431	Episode 2 of Course 31	Dignissimos commodi eius non ullam id sunt praesentium incidunt. Eaque dolore repudiandae a. Quia voluptas sunt asperiores minima perspiciatis.	\N	\N	\N	\N	f
1293	431	Episode 3 of Course 31	Animi pariatur sit fugiat. Ut doloremque illo et et voluptatem vel officiis. Et sit suscipit rem quam tempore repellendus qui nihil.	\N	\N	\N	\N	f
1294	432	Episode 1 of Course 32	Modi aut quis ratione fugiat beatae et occaecati. Repudiandae debitis dolorum et iusto vel libero velit.	\N	\N	\N	\N	t
1295	432	Episode 2 of Course 32	Amet error natus voluptas soluta non nihil. Et et ipsum qui eius temporibus. Enim quis quibusdam quas eligendi inventore distinctio dolore et.	\N	\N	\N	\N	f
1296	432	Episode 3 of Course 32	Earum assumenda reprehenderit in. Ad illum deserunt sit rerum. Neque id sed sed quos.	\N	\N	\N	\N	f
1297	433	Episode 1 of Course 33	Aut inventore ipsam sequi nesciunt. Minima exercitationem dignissimos cum incidunt.	\N	\N	\N	\N	t
1298	433	Episode 2 of Course 33	Rerum voluptas facere ad vero repellendus asperiores. Itaque minus dolores ut aut corrupti reiciendis vitae atque. Amet dolores accusantium voluptate expedita aliquid et aut quam.	\N	\N	\N	\N	f
1299	433	Episode 3 of Course 33	Sunt eligendi quo enim. Est minus rerum ut repellat soluta eum. Voluptas voluptatum libero quia incidunt blanditiis.	\N	\N	\N	\N	f
1300	434	Episode 1 of Course 34	Deserunt ut reprehenderit ut. Veniam fuga fuga occaecati accusantium fuga iusto saepe.	\N	\N	\N	\N	t
1301	434	Episode 2 of Course 34	Error non ex expedita atque enim sit. Sapiente sunt rerum ut accusamus repellat. Consequuntur velit reprehenderit ullam laudantium fugit.	\N	\N	\N	\N	f
1302	434	Episode 3 of Course 34	Voluptas nostrum est dolorum et eos non sed. Quasi quibusdam quia omnis ipsam magnam. Ut culpa doloremque voluptatem illo debitis molestiae.	\N	\N	\N	\N	f
1303	435	Episode 1 of Course 35	Libero sed rerum aut est beatae qui placeat. Et accusamus ullam dolorem.	\N	\N	\N	\N	t
1304	435	Episode 2 of Course 35	Fugit accusantium excepturi est. Illo nihil eligendi dolor quis sint consequatur. Inventore nihil autem tenetur pariatur incidunt illum.	\N	\N	\N	\N	f
1305	435	Episode 3 of Course 35	Iste eaque explicabo maiores eveniet. Expedita repudiandae accusantium velit. Praesentium dolore ut ipsam.	\N	\N	\N	\N	f
1306	436	Episode 1 of Course 36	Saepe consequatur atque eum quo est sequi nam aperiam. Aut distinctio sequi saepe a voluptatem libero.	\N	\N	\N	\N	t
1307	436	Episode 2 of Course 36	In aut omnis unde officia sint inventore rem. Reprehenderit enim non et mollitia. Sapiente eum cumque deserunt quibusdam quia dolor rem nobis.	\N	\N	\N	\N	f
1308	436	Episode 3 of Course 36	Sunt ipsam quae sed dolores quas quaerat. Suscipit dignissimos qui pariatur aliquid provident occaecati in. Dolorum omnis ducimus omnis nobis dolor eligendi nihil.	\N	\N	\N	\N	f
1309	437	Episode 1 of Course 37	Non ducimus necessitatibus inventore et veniam a temporibus. Accusantium totam provident vero voluptatem voluptatem.	\N	\N	\N	\N	t
1310	437	Episode 2 of Course 37	Aperiam at quisquam reiciendis. Ipsum veritatis vero quibusdam. Nulla sit reiciendis natus a asperiores tempora praesentium.	\N	\N	\N	\N	f
1311	437	Episode 3 of Course 37	Iure et libero quo aut ut incidunt. Cumque delectus perferendis officia eaque id et. Ut eligendi molestiae maiores eaque repellat molestias repudiandae.	\N	\N	\N	\N	f
1312	438	Episode 1 of Course 38	Accusantium quasi dignissimos ipsa consectetur in voluptatem corrupti. Dolorem nihil sit voluptas expedita cupiditate.	\N	\N	\N	\N	t
1313	438	Episode 2 of Course 38	Ea ducimus veritatis ut amet eius. Voluptate quae dolorem sapiente nihil explicabo sit. Omnis repellat quo nihil.	\N	\N	\N	\N	f
1314	438	Episode 3 of Course 38	Nam optio sint ut dolor magnam reprehenderit libero. Harum nobis vel nemo cupiditate quia beatae eligendi. Quia voluptatibus sed doloremque modi.	\N	\N	\N	\N	f
1315	439	Episode 1 of Course 39	Qui tempore autem ratione cum sunt modi. Repellendus neque et laborum ullam occaecati qui ex.	\N	\N	\N	\N	t
1316	439	Episode 2 of Course 39	Error reiciendis officiis sit architecto. Perferendis iste illum eos eaque et. Rerum itaque dolore doloribus quod explicabo est quo.	\N	\N	\N	\N	f
1317	439	Episode 3 of Course 39	Sit repellat distinctio deleniti dolor occaecati. Voluptatem nihil voluptate qui eos praesentium sint quia. Enim autem quidem illo aliquam fuga.	\N	\N	\N	\N	f
1318	440	Episode 1 of Course 40	Totam adipisci omnis dignissimos aspernatur. Aut atque nobis tenetur quos veritatis consectetur aut.	\N	\N	\N	\N	t
1319	440	Episode 2 of Course 40	Dolores pariatur nostrum impedit. Blanditiis non animi aut veniam et. Soluta similique quis molestiae odio labore sit at dolorum.	\N	\N	\N	\N	f
1320	440	Episode 3 of Course 40	Et eveniet accusantium voluptatem voluptatum. Est vero voluptatibus fuga expedita soluta occaecati repellendus tempore. Voluptatem commodi cupiditate reprehenderit repellendus.	\N	\N	\N	\N	f
1321	441	Episode 1 of Course 41	Dolores perferendis provident doloribus. Explicabo aut incidunt itaque quidem quaerat.	\N	\N	\N	\N	t
1322	441	Episode 2 of Course 41	Amet natus aliquam sunt molestiae eius dignissimos quibusdam. Harum et et voluptas qui voluptatem sint. Quo et qui sit eos.	\N	\N	\N	\N	f
1323	441	Episode 3 of Course 41	Facere fugit temporibus eum eum ut unde hic. Nobis at perspiciatis natus non quasi ullam quod. Et eum aliquam vel.	\N	\N	\N	\N	f
1324	442	Episode 1 of Course 42	Corporis sit a quibusdam doloribus. Eius sed rerum eum.	\N	\N	\N	\N	t
1325	442	Episode 2 of Course 42	In sit qui aliquid occaecati id. Repellendus praesentium fuga ea libero magni eum vel vero. Aut numquam recusandae est ut assumenda.	\N	\N	\N	\N	f
1326	442	Episode 3 of Course 42	Qui quibusdam dolorum iure odio. Sunt voluptas cupiditate et mollitia quibusdam. Adipisci ratione rerum numquam et earum laboriosam.	\N	\N	\N	\N	f
1327	443	Episode 1 of Course 43	Laborum totam aut officia suscipit. Eos natus sint aut officiis.	\N	\N	\N	\N	t
1328	443	Episode 2 of Course 43	Non iure eos quaerat repudiandae rerum expedita. Enim nihil iste facere. Velit eaque expedita est numquam aspernatur.	\N	\N	\N	\N	f
1329	443	Episode 3 of Course 43	Saepe veritatis dolorem corporis laboriosam totam amet. Et temporibus placeat excepturi praesentium aut dicta cumque est. Sit voluptatum hic cumque et culpa.	\N	\N	\N	\N	f
1330	444	Episode 1 of Course 44	Occaecati nihil rerum saepe. Suscipit quibusdam nesciunt omnis placeat suscipit sit.	\N	\N	\N	\N	t
1331	444	Episode 2 of Course 44	Iure qui voluptas vitae dolor. Quae sit aperiam quis possimus dolorem perspiciatis dolor. Officia itaque eaque ipsum.	\N	\N	\N	\N	f
1332	444	Episode 3 of Course 44	Repellendus et fugiat ipsam modi consequatur consequatur. Rem eveniet quidem quod id. Tempora et repudiandae possimus maiores ab.	\N	\N	\N	\N	f
1333	445	Episode 1 of Course 45	Cupiditate dignissimos dicta et aut dolor. In eos vitae aut accusantium.	\N	\N	\N	\N	t
1334	445	Episode 2 of Course 45	Corrupti nulla repudiandae veniam deserunt. Harum quo nulla quam et ea. At minima cumque voluptatem qui.	\N	\N	\N	\N	f
1335	445	Episode 3 of Course 45	Debitis iusto velit omnis quia. Eligendi molestias tempore vitae vel modi. Nesciunt dolores voluptatibus atque nesciunt autem veniam sint.	\N	\N	\N	\N	f
1336	446	Episode 1 of Course 46	Qui eos et veritatis. Atque pariatur minima est neque veritatis eaque dolorem.	\N	\N	\N	\N	t
1337	446	Episode 2 of Course 46	Ut consequatur et reprehenderit temporibus animi molestias. Saepe totam iure vero. Consequuntur aut quisquam aliquid odio.	\N	\N	\N	\N	f
1338	446	Episode 3 of Course 46	Facilis voluptatem consequatur cumque voluptatem esse. Velit nihil atque veniam adipisci ut harum. Ut praesentium perferendis debitis molestiae quo qui.	\N	\N	\N	\N	f
1339	447	Episode 1 of Course 47	Et ut tempore soluta delectus atque et velit. Nemo accusantium rerum harum veritatis in doloremque.	\N	\N	\N	\N	t
1340	447	Episode 2 of Course 47	Quos et quasi dicta animi est molestiae quisquam. Voluptatem ut eveniet nobis eveniet ea. Quam ea fugit aut et numquam beatae.	\N	\N	\N	\N	f
1341	447	Episode 3 of Course 47	Reiciendis laudantium possimus dolorem et minima quis tenetur. Nobis aperiam odio itaque ex eveniet sequi dignissimos. Esse aut placeat omnis ullam.	\N	\N	\N	\N	f
1342	448	Episode 1 of Course 48	Eos est fuga debitis aut ut sit nulla modi. Pariatur sunt reprehenderit delectus reprehenderit repellat a.	\N	\N	\N	\N	t
1343	448	Episode 2 of Course 48	Distinctio eos blanditiis quaerat non fuga impedit quae. Facere nesciunt in unde optio praesentium. Itaque aut ab modi voluptas.	\N	\N	\N	\N	f
1344	448	Episode 3 of Course 48	Corrupti rerum adipisci ullam eligendi similique. Ut nemo magni in assumenda officia. Omnis qui velit non inventore ratione suscipit sint vitae.	\N	\N	\N	\N	f
1345	449	Episode 1 of Course 49	Est et nihil ex consectetur. Qui facilis a aliquid dolorem debitis laborum.	\N	\N	\N	\N	t
1346	449	Episode 2 of Course 49	Magni unde quis ea maiores. Deleniti dolores quo est tenetur quaerat amet et unde. Et voluptas eos nesciunt quas.	\N	\N	\N	\N	f
1347	449	Episode 3 of Course 49	Porro itaque enim ratione provident. Dignissimos temporibus quo nisi porro eligendi magnam. Voluptatum veritatis veniam perspiciatis minus odio quia.	\N	\N	\N	\N	f
1348	450	Episode 1 of Course 50	Perspiciatis accusantium est a quisquam. Omnis excepturi aut at iusto.	\N	\N	\N	\N	t
1349	450	Episode 2 of Course 50	In enim quia rerum alias. Non pariatur ea ut sunt. Nulla et perspiciatis tempora eos nostrum exercitationem error.	\N	\N	\N	\N	f
1350	450	Episode 3 of Course 50	Delectus et perferendis quas magni dignissimos officiis sapiente. Est qui eaque deserunt exercitationem consequuntur vitae eum doloribus. Optio ducimus rem aliquid.	\N	\N	\N	\N	f
1351	451	Episode 1 of Course 51	Assumenda aut odio exercitationem est earum. Culpa et et unde eum provident explicabo officia.	\N	\N	\N	\N	t
1352	451	Episode 2 of Course 51	Quis rerum est asperiores ut blanditiis aut itaque. Enim rerum totam ea iste. Doloremque eligendi dolores suscipit in earum perferendis id.	\N	\N	\N	\N	f
1353	451	Episode 3 of Course 51	Repudiandae molestias est repellendus et suscipit aut. Possimus et ipsum autem nam et explicabo deleniti repellendus. Exercitationem officia a dolorem ratione laborum harum et.	\N	\N	\N	\N	f
1354	452	Episode 1 of Course 52	Repudiandae dolores cum aperiam voluptatem. Rerum veritatis quis voluptatem.	\N	\N	\N	\N	t
1355	452	Episode 2 of Course 52	Eveniet minima culpa nam magni nobis magnam. Cupiditate iure dolore aperiam qui omnis. Distinctio consequatur sit quaerat a ut.	\N	\N	\N	\N	f
1356	452	Episode 3 of Course 52	Delectus vel quo inventore iure eos magnam consequatur. Error et rerum aut a deserunt reiciendis nesciunt beatae. Amet et repudiandae veniam iure.	\N	\N	\N	\N	f
1357	453	Episode 1 of Course 53	Sed dolorum suscipit porro ea. At quis aut accusantium est.	\N	\N	\N	\N	t
1358	453	Episode 2 of Course 53	Cumque delectus id laborum quos. Unde hic illum quasi. Nam perferendis repudiandae veritatis illo neque amet.	\N	\N	\N	\N	f
1359	453	Episode 3 of Course 53	Nam ut voluptas doloremque corporis ipsam. Est et similique voluptatem laboriosam molestiae. Iure veritatis laudantium voluptatem temporibus quod.	\N	\N	\N	\N	f
1360	454	Episode 1 of Course 54	Nam deleniti ipsa odit assumenda quaerat veritatis. Voluptate pariatur iusto omnis voluptatem.	\N	\N	\N	\N	t
1361	454	Episode 2 of Course 54	Voluptatum minus reprehenderit non est qui dignissimos facilis. Rerum itaque nam odit natus et error natus. Minus modi error adipisci saepe explicabo atque.	\N	\N	\N	\N	f
1362	454	Episode 3 of Course 54	Possimus libero minus neque omnis voluptatum blanditiis aperiam est. Aut reprehenderit fugiat nihil. Minus asperiores corrupti pariatur quisquam veritatis.	\N	\N	\N	\N	f
1363	455	Episode 1 of Course 55	Sed eum numquam magni. Esse non repellat excepturi.	\N	\N	\N	\N	t
1364	455	Episode 2 of Course 55	Sit corporis qui consequatur explicabo ea qui magni dicta. Incidunt minima corporis enim accusamus ducimus suscipit odit ea. Quasi et qui animi quod.	\N	\N	\N	\N	f
1365	455	Episode 3 of Course 55	Hic fuga eius dolorem nam. Eos quos velit ea ut eum optio. Rerum repudiandae possimus quia ex tenetur.	\N	\N	\N	\N	f
1366	456	Episode 1 of Course 56	Unde accusantium quasi sint consequuntur. Ducimus nemo omnis et facere.	\N	\N	\N	\N	t
1367	456	Episode 2 of Course 56	Rerum ut minus hic eum. Dolor autem sequi libero provident minus quia. Enim iste non nisi.	\N	\N	\N	\N	f
1368	456	Episode 3 of Course 56	Voluptatem occaecati dolorem consectetur qui sit quia. Esse incidunt quod rem exercitationem reiciendis aut. Neque maxime sed voluptas odio laborum delectus inventore.	\N	\N	\N	\N	f
1369	457	Episode 1 of Course 57	Magnam sapiente modi in. Totam ea qui dolore.	\N	\N	\N	\N	t
1370	457	Episode 2 of Course 57	Deleniti eum deserunt et odio. Eaque non enim soluta dolorem voluptatem. Voluptas provident saepe amet.	\N	\N	\N	\N	f
1371	457	Episode 3 of Course 57	Eos et et ducimus perferendis et. Aliquid ducimus suscipit ea cumque ut quas quia. Sequi quisquam architecto ut assumenda.	\N	\N	\N	\N	f
1372	458	Episode 1 of Course 58	In iusto eius illum. Nostrum sint alias pariatur.	\N	\N	\N	\N	t
1373	458	Episode 2 of Course 58	Doloribus rem blanditiis est quibusdam aperiam. Harum eum voluptatem cumque eligendi non placeat voluptate. Non inventore beatae enim eveniet.	\N	\N	\N	\N	f
1374	458	Episode 3 of Course 58	Praesentium non ducimus architecto aliquam. Laborum voluptas quia nihil ut facilis. Tenetur laborum rerum et nostrum laudantium nihil.	\N	\N	\N	\N	f
1375	459	Episode 1 of Course 59	Earum corporis inventore deleniti qui laudantium qui. Quam repellat aliquid et sint deserunt ut consequatur.	\N	\N	\N	\N	t
1376	459	Episode 2 of Course 59	Est maxime perspiciatis sed consequatur nihil. Laboriosam dolorem vel aliquam modi in perspiciatis et. Eveniet et aliquam dolorem aliquid.	\N	\N	\N	\N	f
1377	459	Episode 3 of Course 59	Esse natus delectus aut omnis dicta. Quia qui commodi et et dolorem. Nihil dolor adipisci consequatur reiciendis tempora sed voluptates.	\N	\N	\N	\N	f
1378	460	Episode 1 of Course 60	Ut sed libero voluptates eaque earum id similique. Enim quos aut voluptatem.	\N	\N	\N	\N	t
1379	460	Episode 2 of Course 60	Officiis eum inventore laborum natus quia molestiae. Similique sint similique reprehenderit dolore ut ratione voluptatibus. Odio vero ut quis et.	\N	\N	\N	\N	f
1380	460	Episode 3 of Course 60	Explicabo doloribus quisquam totam doloribus. Aut minima consequatur adipisci voluptatem. Et nulla sint nisi quia consequuntur sequi aliquid.	\N	\N	\N	\N	f
1381	461	Episode 1 of Course 61	Sit vel enim possimus nostrum ipsam. Itaque vero impedit tempora voluptas et corrupti repellendus.	\N	\N	\N	\N	t
1382	461	Episode 2 of Course 61	Expedita incidunt qui est numquam ratione officiis non ut. Architecto architecto ullam temporibus velit. Accusamus est et voluptas repellendus nostrum eius.	\N	\N	\N	\N	f
1383	461	Episode 3 of Course 61	Laboriosam voluptatem similique culpa sunt iusto. Harum vero quia dolores autem optio sunt est. Omnis qui ipsa ducimus cumque possimus labore possimus.	\N	\N	\N	\N	f
1384	462	Episode 1 of Course 62	Aliquam sit nostrum repellat eveniet. Doloribus molestiae consequatur officiis magni quisquam et ea.	\N	\N	\N	\N	t
1385	462	Episode 2 of Course 62	Dolores provident et veritatis aut explicabo aperiam necessitatibus. Perferendis sed sit doloremque aut. Aperiam sapiente et harum ducimus amet dolorem.	\N	\N	\N	\N	f
1386	462	Episode 3 of Course 62	Dolor assumenda similique rerum dolores quis alias. Totam sed est natus eligendi ut voluptas temporibus. Libero laborum soluta accusamus fuga voluptatum in dignissimos non.	\N	\N	\N	\N	f
1387	463	Episode 1 of Course 63	Sequi vel qui vel fugiat similique omnis laudantium. Est at aut dignissimos culpa quibusdam deserunt.	\N	\N	\N	\N	t
1388	463	Episode 2 of Course 63	Animi voluptatem incidunt sit animi aut. Dolore facere ut quibusdam nihil voluptas voluptas ea. Possimus sequi non dolore iste nostrum rem.	\N	\N	\N	\N	f
1389	463	Episode 3 of Course 63	Id non qui quas. Ea amet quod voluptatibus aut debitis. Asperiores dolores sint qui quasi.	\N	\N	\N	\N	f
1390	464	Episode 1 of Course 64	Esse qui labore voluptatem sint. Esse voluptates architecto unde ducimus impedit autem aut.	\N	\N	\N	\N	t
1391	464	Episode 2 of Course 64	Ad explicabo eos voluptas quasi deleniti. Repellat accusantium corrupti ducimus sit iste. Id aut fugit dicta porro.	\N	\N	\N	\N	f
1392	464	Episode 3 of Course 64	Voluptatibus sit voluptas minus est sunt accusamus doloremque. Sit ipsum eos non. Nam aut ipsa et nulla qui.	\N	\N	\N	\N	f
1393	465	Episode 1 of Course 65	Velit veniam sit dolorum ut debitis eum. Atque enim totam porro.	\N	\N	\N	\N	t
1394	465	Episode 2 of Course 65	Doloribus saepe molestias dolorem ipsum omnis eum et quis. Consequatur saepe ad ipsum sit. Excepturi itaque labore deleniti libero suscipit.	\N	\N	\N	\N	f
1395	465	Episode 3 of Course 65	Quaerat quisquam amet perspiciatis ratione aut laudantium consequatur similique. Sint qui in totam saepe voluptatem. Vitae commodi perspiciatis magni et voluptatem voluptatem omnis.	\N	\N	\N	\N	f
1396	466	Episode 1 of Course 66	Accusamus aut praesentium ut placeat. Qui consequuntur sint nesciunt minus quia accusantium.	\N	\N	\N	\N	t
1397	466	Episode 2 of Course 66	Nulla officia nihil rerum officia. Voluptatum maxime inventore laborum voluptatibus odit enim. Accusantium omnis rerum voluptatem qui quam qui.	\N	\N	\N	\N	f
1398	466	Episode 3 of Course 66	Quia iste alias dolor qui nihil et labore. Omnis aut fugit quis odio dolorem ullam nostrum eligendi. Omnis et rem consequatur in a inventore iure.	\N	\N	\N	\N	f
1399	467	Episode 1 of Course 67	Quo dolore minus ut laboriosam placeat. Sit vel facere enim alias similique nostrum.	\N	\N	\N	\N	t
1400	467	Episode 2 of Course 67	Libero fuga soluta id dolorem dignissimos earum autem. Quaerat sint nisi quaerat cumque. Ut magni ad similique est id voluptatem unde.	\N	\N	\N	\N	f
1401	467	Episode 3 of Course 67	Ea minima magni quibusdam autem ex. Omnis repellat voluptates voluptate sapiente voluptas ullam nisi. Sapiente optio veniam in corrupti reiciendis iure.	\N	\N	\N	\N	f
1402	468	Episode 1 of Course 68	Ut reiciendis aliquid quo. Voluptatem est iusto quas facere non odio praesentium.	\N	\N	\N	\N	t
1403	468	Episode 2 of Course 68	Quia excepturi dolorem eveniet a ab. Dolore ut at quis asperiores quia aliquam omnis. Explicabo dolorem quas placeat et quo reprehenderit.	\N	\N	\N	\N	f
1404	468	Episode 3 of Course 68	Sed sunt provident nihil quaerat rerum. Eligendi unde nostrum expedita sit eos temporibus. Amet sit quidem nobis blanditiis nostrum.	\N	\N	\N	\N	f
1405	469	Episode 1 of Course 69	Reiciendis ratione eveniet velit sapiente enim. Eum distinctio consequatur ipsam vero.	\N	\N	\N	\N	t
1406	469	Episode 2 of Course 69	Ullam fugiat pariatur est consequatur. In exercitationem laborum maiores facere. Expedita eveniet sint sint illo velit qui deserunt.	\N	\N	\N	\N	f
1407	469	Episode 3 of Course 69	Et libero eius reprehenderit a vitae sint mollitia. Optio accusamus doloribus aut sit culpa tenetur quasi iure. Minus sed laboriosam ut sunt omnis ut.	\N	\N	\N	\N	f
1408	470	Episode 1 of Course 70	Minus provident qui quae suscipit. Quam quo libero veritatis aut voluptas totam similique.	\N	\N	\N	\N	t
1409	470	Episode 2 of Course 70	Laudantium debitis quo architecto nemo placeat error excepturi et. Asperiores nihil eveniet velit. Delectus eligendi rem aut voluptatem qui quas dolorem velit.	\N	\N	\N	\N	f
1410	470	Episode 3 of Course 70	Nostrum eum voluptatem nulla dolor quas tenetur et. Possimus perspiciatis ut maiores. Alias commodi cumque occaecati tempore laborum et et illo.	\N	\N	\N	\N	f
1411	471	Episode 1 of Course 71	Sed et aliquid repudiandae hic debitis ipsam. Vel nemo qui magnam maiores quibusdam odit.	\N	\N	\N	\N	t
1412	471	Episode 2 of Course 71	Cumque error maxime repellendus nostrum. Corrupti omnis in sit quaerat laboriosam. Omnis distinctio ipsum eum ratione sint.	\N	\N	\N	\N	f
1413	471	Episode 3 of Course 71	Nemo dolor omnis quas dolor id minima officiis enim. Dolore saepe delectus rem dolorum. Quis eos doloribus nisi numquam voluptatem pariatur.	\N	\N	\N	\N	f
1414	472	Episode 1 of Course 72	Quos facilis quos alias atque. Et atque distinctio cumque sed.	\N	\N	\N	\N	t
1415	472	Episode 2 of Course 72	Deleniti sapiente est rerum iste et et sunt quisquam. Voluptatem dolores consequuntur tempora aut quos et distinctio ut. Occaecati necessitatibus dicta quod nemo.	\N	\N	\N	\N	f
1416	472	Episode 3 of Course 72	Expedita illum rerum voluptatem nesciunt veritatis odio distinctio. Id ullam aut eum aperiam qui voluptatem. Libero quidem iure dolorem velit nobis aut.	\N	\N	\N	\N	f
1417	473	Episode 1 of Course 73	Consequatur quaerat dolorem repellendus nihil doloribus totam ex. Similique soluta eum deserunt non dicta.	\N	\N	\N	\N	t
1418	473	Episode 2 of Course 73	Expedita nesciunt architecto consequatur aspernatur et dolorum doloremque delectus. Dolor fuga dolorem officiis dicta repellat ipsa sunt. Molestiae cupiditate est quasi minus veritatis ipsum.	\N	\N	\N	\N	f
1419	473	Episode 3 of Course 73	Quia et molestiae optio aliquid pariatur dolorum rerum. Accusamus sint non est sed officia non. Perspiciatis perferendis qui velit soluta voluptatibus voluptatum et.	\N	\N	\N	\N	f
1420	474	Episode 1 of Course 74	Temporibus laboriosam fugiat ducimus blanditiis sapiente placeat. Quaerat voluptatem a totam.	\N	\N	\N	\N	t
1421	474	Episode 2 of Course 74	Corrupti tempore modi consequatur cumque dolor est non. Non maxime nisi quasi atque tenetur nostrum. Molestiae ab id autem nam.	\N	\N	\N	\N	f
1422	474	Episode 3 of Course 74	Et explicabo accusamus beatae asperiores suscipit voluptas dolor. Et ipsam odit vero a fuga tenetur molestias iure. Quam consequatur repellendus quaerat itaque vitae totam nulla.	\N	\N	\N	\N	f
1423	475	Episode 1 of Course 75	Architecto nulla dolorum iusto et debitis. Temporibus aut cupiditate sequi culpa nulla.	\N	\N	\N	\N	t
1424	475	Episode 2 of Course 75	Dolores eligendi occaecati adipisci nihil sunt. Consectetur minima ad omnis libero in rerum officia. Quisquam dolore id quos nemo.	\N	\N	\N	\N	f
1425	475	Episode 3 of Course 75	Voluptatibus consectetur vel maiores ipsa. Id consequatur expedita atque et. Dolores voluptatem quasi amet.	\N	\N	\N	\N	f
1426	476	Episode 1 of Course 76	Quia omnis labore animi expedita sed illum labore. Sit deleniti voluptatem aut non non.	\N	\N	\N	\N	t
1427	476	Episode 2 of Course 76	Quam quibusdam quia sint optio adipisci culpa consectetur. Repellendus est illo autem assumenda nesciunt similique et. Voluptas quis molestias illum qui sit omnis.	\N	\N	\N	\N	f
1428	476	Episode 3 of Course 76	Ea beatae voluptas hic harum facere. Est qui voluptatem perspiciatis quo. Ratione rem dicta id ut.	\N	\N	\N	\N	f
1429	477	Episode 1 of Course 77	Voluptas molestiae in non esse magnam. Accusantium temporibus consectetur hic aut sed.	\N	\N	\N	\N	t
1430	477	Episode 2 of Course 77	Fugiat dolorem cumque magnam suscipit cupiditate in. Non voluptatem cumque et. Rerum est praesentium officiis natus id.	\N	\N	\N	\N	f
1431	477	Episode 3 of Course 77	Est ut numquam dolor est tenetur beatae. Aspernatur earum et dolorum beatae amet. At numquam rem non dicta non.	\N	\N	\N	\N	f
1432	478	Episode 1 of Course 78	Cumque pariatur provident nobis porro dignissimos repudiandae voluptatem. Illo ea aspernatur deserunt eligendi laboriosam repellendus.	\N	\N	\N	\N	t
1433	478	Episode 2 of Course 78	Eaque iste voluptatibus quis. Repellat rerum consequatur quibusdam architecto et. Non repudiandae corporis molestiae at.	\N	\N	\N	\N	f
1434	478	Episode 3 of Course 78	Et magni quod sint nam. Laborum iusto dicta aut et et ad. Enim temporibus quibusdam et modi.	\N	\N	\N	\N	f
1435	479	Episode 1 of Course 79	Occaecati rerum ut voluptatem perspiciatis nesciunt. Saepe pariatur sequi tempore architecto sunt.	\N	\N	\N	\N	t
1436	479	Episode 2 of Course 79	Ex aut accusamus nam autem mollitia. Quia nostrum illum illo suscipit. Quia esse modi omnis et est nesciunt dolores.	\N	\N	\N	\N	f
1437	479	Episode 3 of Course 79	Magni corrupti quibusdam velit et. Hic at assumenda sequi ad corrupti. Ullam ratione veniam vel placeat pariatur incidunt quia.	\N	\N	\N	\N	f
1438	480	Episode 1 of Course 80	Id quam praesentium quia enim sit. Officiis ea ducimus alias in.	\N	\N	\N	\N	t
1439	480	Episode 2 of Course 80	Totam facilis quia aut itaque vel. Praesentium inventore aut mollitia rerum. Aspernatur placeat cupiditate quas atque.	\N	\N	\N	\N	f
1440	480	Episode 3 of Course 80	Qui doloribus id omnis distinctio. Quibusdam ducimus ad nihil ullam. Voluptatem aut error ea et.	\N	\N	\N	\N	f
1441	481	Episode 1 of Course 81	Tempora adipisci incidunt ullam deserunt vel ea. Autem ut rerum minima ipsam voluptatem consequatur nostrum.	\N	\N	\N	\N	t
1442	481	Episode 2 of Course 81	Optio ipsa voluptatem assumenda aliquam. Quo consequuntur iure consequatur. Incidunt cum impedit qui rerum placeat eos autem omnis.	\N	\N	\N	\N	f
1443	481	Episode 3 of Course 81	Quo sed sunt tempore repellendus. Ea aliquid voluptatem quis quia nihil cum. Ea facilis autem repudiandae magni.	\N	\N	\N	\N	f
1444	482	Episode 1 of Course 82	Et eaque quia minima dicta. Inventore eum ea expedita aut in ab.	\N	\N	\N	\N	t
1445	482	Episode 2 of Course 82	Tenetur quis nemo saepe fuga rerum. At incidunt perferendis error enim facilis. Vitae molestiae iusto ullam ad quaerat ad dicta quibusdam.	\N	\N	\N	\N	f
1446	482	Episode 3 of Course 82	Est soluta saepe pariatur repudiandae dignissimos illum. Dolorum qui veniam consequuntur ratione. Modi dolorum veritatis qui.	\N	\N	\N	\N	f
1447	483	Episode 1 of Course 83	Placeat aut aspernatur officia sint odio id reiciendis omnis. Aut a et a aut voluptas et.	\N	\N	\N	\N	t
1448	483	Episode 2 of Course 83	Mollitia eaque nulla quia nisi quod doloribus. Aut aut necessitatibus blanditiis doloribus. Rerum reprehenderit repudiandae et vel aspernatur non quisquam.	\N	\N	\N	\N	f
1449	483	Episode 3 of Course 83	Et minus architecto doloribus eligendi possimus praesentium et. Laudantium recusandae non provident nihil. Repellat ut harum voluptatibus dolores consequatur.	\N	\N	\N	\N	f
1450	484	Episode 1 of Course 84	Rerum est tenetur aliquam doloremque. Sed dolorem officia velit sit totam blanditiis.	\N	\N	\N	\N	t
1451	484	Episode 2 of Course 84	Mollitia quisquam officiis distinctio ut impedit. Eveniet laboriosam sequi inventore aperiam. Qui nesciunt cupiditate ea et et possimus illo.	\N	\N	\N	\N	f
1452	484	Episode 3 of Course 84	Fugit iure ratione rerum maxime. Minima nemo laboriosam cum voluptatem dolor. Excepturi ipsam ducimus eum error adipisci.	\N	\N	\N	\N	f
1453	485	Episode 1 of Course 85	Perferendis laudantium fugiat vero aut qui. Voluptatem vitae ea ut iusto sapiente optio.	\N	\N	\N	\N	t
1454	485	Episode 2 of Course 85	Consequatur qui at est. Et fuga harum aut repellat pariatur voluptatem. Corporis qui enim non velit.	\N	\N	\N	\N	f
1455	485	Episode 3 of Course 85	Aperiam illum laboriosam eaque ipsam accusamus deserunt. Cupiditate velit tempore tempora error commodi eveniet nesciunt. Earum distinctio consequatur quaerat praesentium nulla nostrum debitis.	\N	\N	\N	\N	f
1456	486	Episode 1 of Course 86	Qui magni fugiat eos a qui. Non et quibusdam sed velit est quis.	\N	\N	\N	\N	t
1457	486	Episode 2 of Course 86	Veritatis enim eveniet nesciunt velit. Est qui aperiam adipisci nisi. Non corporis enim corporis ut qui excepturi dolorum.	\N	\N	\N	\N	f
1458	486	Episode 3 of Course 86	Illum aut qui esse architecto perferendis. Vero tempora iusto optio veritatis. Et iure enim ut ut fuga veniam.	\N	\N	\N	\N	f
1459	487	Episode 1 of Course 87	Placeat sed repellat qui possimus. Expedita culpa quia qui.	\N	\N	\N	\N	t
1460	487	Episode 2 of Course 87	Iure perferendis cumque laborum. Sequi quisquam numquam optio ut voluptas. Illum quas possimus et dolores aut id excepturi.	\N	\N	\N	\N	f
1461	487	Episode 3 of Course 87	Incidunt rem id quaerat sed tempore iste autem. Animi nesciunt reprehenderit maxime eos est illum qui. At neque tempora et laboriosam necessitatibus facere quod.	\N	\N	\N	\N	f
1462	488	Episode 1 of Course 88	Aut est veniam aut est doloribus voluptas laborum. Aut hic maiores nemo occaecati dolorum delectus nostrum.	\N	\N	\N	\N	t
1463	488	Episode 2 of Course 88	Qui deserunt animi impedit quam voluptatem. Molestias enim doloribus repellat velit quos soluta. Veniam non quis et.	\N	\N	\N	\N	f
1464	488	Episode 3 of Course 88	Praesentium ut ea temporibus qui dignissimos maxime. Reiciendis rerum distinctio dolores at aliquid non. Fugiat sequi libero et et itaque aut omnis et.	\N	\N	\N	\N	f
1465	489	Episode 1 of Course 89	Nisi ipsum eligendi est eveniet possimus est. Optio id voluptas ipsa perspiciatis numquam repellendus exercitationem.	\N	\N	\N	\N	t
1466	489	Episode 2 of Course 89	Numquam non omnis ab nemo aut nihil. Repellat perspiciatis animi dolor ullam. Ut at officiis et accusamus consequuntur aliquid ducimus alias.	\N	\N	\N	\N	f
1467	489	Episode 3 of Course 89	Omnis quia sint quisquam nisi sint. Quam quis cumque magnam consectetur illo optio nihil. Quis sunt neque aut et.	\N	\N	\N	\N	f
1468	490	Episode 1 of Course 90	Rerum voluptas quos iure. Earum dolores possimus corrupti fugiat alias suscipit.	\N	\N	\N	\N	t
1469	490	Episode 2 of Course 90	Itaque et nisi voluptatum et. Qui animi assumenda qui et et voluptatem neque et. Ut et aut esse ea consectetur.	\N	\N	\N	\N	f
1470	490	Episode 3 of Course 90	Consequatur et occaecati voluptatem quos voluptatum et temporibus. Quis assumenda fugiat iste error dolorem. Ut cumque et voluptatem error est.	\N	\N	\N	\N	f
1471	491	Episode 1 of Course 91	Debitis rerum esse aliquid sequi expedita excepturi. Enim excepturi quam aspernatur quisquam aut eos illum.	\N	\N	\N	\N	t
1472	491	Episode 2 of Course 91	Sed quod dolore enim quia doloribus quae autem enim. Qui ut ut enim eos dolor aperiam maiores. Quidem officiis quibusdam perferendis iste in ipsam enim.	\N	\N	\N	\N	f
1473	491	Episode 3 of Course 91	Rem voluptas id magni quas sunt. Eum nam rerum itaque quasi doloremque. Ratione dolores fugiat ea libero consequatur sed.	\N	\N	\N	\N	f
1474	492	Episode 1 of Course 92	Nihil non explicabo sed aut. Similique placeat quas reprehenderit corporis.	\N	\N	\N	\N	t
1475	492	Episode 2 of Course 92	Aut eum nobis rerum eum. Dolorem quo non aspernatur et provident. Accusantium consequuntur voluptatem aut qui et laborum repellendus dolorem.	\N	\N	\N	\N	f
1476	492	Episode 3 of Course 92	Ducimus ratione perferendis et minus repellat repellendus. Aliquid voluptatem voluptatem ab incidunt consequatur. Quo et magni eum unde.	\N	\N	\N	\N	f
1477	493	Episode 1 of Course 93	Quasi voluptate culpa voluptatem. Et assumenda est eius maiores nostrum.	\N	\N	\N	\N	t
1478	493	Episode 2 of Course 93	Consectetur et earum et quia enim rem. Ipsam delectus ducimus ea ducimus accusamus. Cum illum eaque unde quae ab aperiam.	\N	\N	\N	\N	f
1479	493	Episode 3 of Course 93	Dolorem culpa eveniet harum ab quis et. Tempora saepe aut laudantium atque atque quo. Molestias quia quos nam autem dolores itaque reiciendis.	\N	\N	\N	\N	f
1480	494	Episode 1 of Course 94	Illum iste doloribus et reprehenderit officiis fuga ut. Labore dolor consequatur rerum quo molestiae ut.	\N	\N	\N	\N	t
1481	494	Episode 2 of Course 94	Cum suscipit inventore deserunt amet nihil. Sunt ut atque magnam et est. Et inventore in possimus eos nemo quas qui.	\N	\N	\N	\N	f
1482	494	Episode 3 of Course 94	Maiores laboriosam velit consequatur. Minus cum necessitatibus neque aperiam id esse quis. Qui explicabo commodi perspiciatis facilis.	\N	\N	\N	\N	f
1483	495	Episode 1 of Course 95	Rerum atque aperiam asperiores quisquam perferendis. Velit explicabo ut eum voluptatum qui.	\N	\N	\N	\N	t
1484	495	Episode 2 of Course 95	Eaque non corporis et voluptas autem esse. Suscipit atque alias consequatur ipsam ea animi repellat. Qui ut vitae atque quia.	\N	\N	\N	\N	f
1485	495	Episode 3 of Course 95	Autem vel ex possimus velit quo eaque. Commodi numquam quas et ipsum sed. Repellendus facere suscipit quibusdam.	\N	\N	\N	\N	f
1486	496	Episode 1 of Course 96	Unde incidunt dicta qui sit quae architecto quasi. Ut officiis et aliquam aut omnis a.	\N	\N	\N	\N	t
1487	496	Episode 2 of Course 96	Sed ullam cupiditate minus impedit ut. Architecto ab earum enim possimus. Odio deleniti est vitae.	\N	\N	\N	\N	f
1488	496	Episode 3 of Course 96	Suscipit sed voluptatem sit voluptas laudantium vel nihil. Ut modi ea odio. Ratione dignissimos similique sint vitae quia quos.	\N	\N	\N	\N	f
1489	497	Episode 1 of Course 97	Eum explicabo quaerat maiores voluptatibus dolor voluptatibus ea sed. Occaecati labore ut ab placeat tempore nesciunt.	\N	\N	\N	\N	t
1490	497	Episode 2 of Course 97	Nostrum facere est ea eum. Eum est dignissimos ullam alias autem iure vel. Ut totam sapiente cumque.	\N	\N	\N	\N	f
1491	497	Episode 3 of Course 97	Perferendis id molestias animi eos. Eos vel explicabo qui nam voluptas. Nobis officiis aliquam inventore.	\N	\N	\N	\N	f
1492	498	Episode 1 of Course 98	Illum velit consequatur illum dolore voluptatem soluta. Vel quam rerum doloribus velit quod esse neque.	\N	\N	\N	\N	t
1493	498	Episode 2 of Course 98	Consequuntur atque magni harum eligendi nobis necessitatibus. Molestiae ut beatae nihil rem veniam. Possimus dolores quae aliquid.	\N	\N	\N	\N	f
1494	498	Episode 3 of Course 98	Ex fugit praesentium et minima voluptas mollitia qui. Non dolorem dolorem aperiam molestiae libero. Sint cum sed quia ut nisi sit eum.	\N	\N	\N	\N	f
1495	499	Episode 1 of Course 99	Mollitia ut non beatae quia aperiam dolorem sit et. Reprehenderit non ex consequatur optio porro.	\N	\N	\N	\N	t
1496	499	Episode 2 of Course 99	Soluta unde asperiores sit doloremque. In non est repellat temporibus. Tenetur suscipit non quibusdam maiores aliquam saepe officia.	\N	\N	\N	\N	f
1497	499	Episode 3 of Course 99	Repudiandae voluptas inventore adipisci maiores impedit atque sit. In quis est et dolor enim. Nemo eum et eaque nostrum error.	\N	\N	\N	\N	f
1498	500	Episode 1 of Course 100	Autem odit ut ducimus inventore perferendis corrupti sunt ad. Iure ratione maxime voluptatum delectus in.	\N	\N	\N	\N	t
1499	500	Episode 2 of Course 100	Rerum minima ut molestias inventore sit eligendi sed. Sunt commodi voluptas porro repellendus et sed. Sit enim voluptatem ut accusamus aspernatur qui explicabo.	\N	\N	\N	\N	f
1500	500	Episode 3 of Course 100	Inventore est animi et eius ea qui earum at. Consectetur autem est iusto enim. Est in facere quasi veniam voluptas laudantium.	\N	\N	\N	\N	f
\.


--
-- TOC entry 4946 (class 0 OID 16760)
-- Dependencies: 238
-- Data for Name: messenger_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messenger_messages (id, body, headers, queue_name, created_at, available_at, delivered_at) FROM stdin;
1	O:36:\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\":2:{s:44:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\";a:1:{s:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\";a:1:{i:0;O:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\":1:{s:55:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\";s:21:\\"messenger.bus.default\\";}}}s:45:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\";O:51:\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\":2:{s:60:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\";O:39:\\"Symfony\\\\Bridge\\\\Twig\\\\Mime\\\\TemplatedEmail\\":5:{i:0;s:41:\\"registration/confirmation_email.html.twig\\";i:1;N;i:2;a:3:{s:9:\\"signedUrl\\";s:174:\\"http://127.0.0.1:8000/email/verified?expires=1734191536&id=106&signature=c%2Fjw0ayHwwu0jbXCso6sqMbHyKRyZNstOxZEY3SwEAE%3D&token=Y1FVl7HBbij7xeVHYGVozaUcpPu3Ery7jvnh36oeNOc%3D\\";s:19:\\"expiresAtMessageKey\\";s:26:\\"%count% hour|%count% hours\\";s:20:\\"expiresAtMessageData\\";a:1:{s:7:\\"%count%\\";i:1;}}i:3;a:6:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;a:0:{}i:5;a:2:{i:0;O:37:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\":2:{s:46:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\";a:3:{s:4:\\"from\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:4:\\"From\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:22:\\"mailgun@CourseSite.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:2:\\"to\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:2:\\"To\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:17:\\"sz425@outlook.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:7:\\"subject\\";a:1:{i:0;O:48:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:7:\\"Subject\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:55:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\";s:25:\\"Please Confirm your Email\\";}}}s:49:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\";i:76;}i:1;N;}}i:4;N;}s:61:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\";N;}}	[]	default	2024-12-14 14:52:17	2024-12-14 14:52:17	\N
2	O:36:\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\":2:{s:44:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\";a:1:{s:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\";a:1:{i:0;O:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\":1:{s:55:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\";s:21:\\"messenger.bus.default\\";}}}s:45:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\";O:51:\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\":2:{s:60:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\";O:39:\\"Symfony\\\\Bridge\\\\Twig\\\\Mime\\\\TemplatedEmail\\":5:{i:0;s:41:\\"registration/confirmation_email.html.twig\\";i:1;N;i:2;a:3:{s:9:\\"signedUrl\\";s:176:\\"http://127.0.0.1:8000/email/verified?expires=1734191635&id=106&signature=A7BGh%2BfIIoLkutQuuOM%2FRtdyWa2erlf4fhYjXJfvv1I%3D&token=Y1FVl7HBbij7xeVHYGVozaUcpPu3Ery7jvnh36oeNOc%3D\\";s:19:\\"expiresAtMessageKey\\";s:26:\\"%count% hour|%count% hours\\";s:20:\\"expiresAtMessageData\\";a:1:{s:7:\\"%count%\\";i:1;}}i:3;a:6:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;a:0:{}i:5;a:2:{i:0;O:37:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\":2:{s:46:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\";a:3:{s:4:\\"from\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:4:\\"From\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:22:\\"mailgun@CourseSite.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:2:\\"to\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:2:\\"To\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:17:\\"sz425@outlook.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:7:\\"subject\\";a:1:{i:0;O:48:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:7:\\"Subject\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:55:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\";s:25:\\"Please Confirm your Email\\";}}}s:49:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\";i:76;}i:1;N;}}i:4;N;}s:61:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\";N;}}	[]	default	2024-12-14 14:53:55	2024-12-14 14:53:55	\N
3	O:36:\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\":2:{s:44:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\";a:1:{s:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\";a:1:{i:0;O:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\":1:{s:55:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\";s:21:\\"messenger.bus.default\\";}}}s:45:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\";O:51:\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\":2:{s:60:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\";O:39:\\"Symfony\\\\Bridge\\\\Twig\\\\Mime\\\\TemplatedEmail\\":5:{i:0;s:41:\\"registration/confirmation_email.html.twig\\";i:1;N;i:2;a:3:{s:9:\\"signedUrl\\";s:188:\\"http://127.0.0.1:8000/email/verified?expires=1734191807&id=107&signature=T3fjVjq2iP%2BnlG5bbGC7%2BN62rUQaO%2BRN48atbYPPMww%3D&token=8BkR%2FK6eaCFJPnP9FZ91v%2Bl%2F7%2B%2BcoWCH9xMkExaDUzo%3D\\";s:19:\\"expiresAtMessageKey\\";s:26:\\"%count% hour|%count% hours\\";s:20:\\"expiresAtMessageData\\";a:1:{s:7:\\"%count%\\";i:1;}}i:3;a:6:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;a:0:{}i:5;a:2:{i:0;O:37:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\":2:{s:46:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\";a:3:{s:4:\\"from\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:4:\\"From\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:22:\\"mailgun@CourseSite.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:2:\\"to\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:2:\\"To\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:11:\\"sz425@wp.pl\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:7:\\"subject\\";a:1:{i:0;O:48:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:7:\\"Subject\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:55:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\";s:25:\\"Please Confirm your Email\\";}}}s:49:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\";i:76;}i:1;N;}}i:4;N;}s:61:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\";N;}}	[]	default	2024-12-14 14:56:47	2024-12-14 14:56:47	\N
4	O:36:\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\":2:{s:44:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\";a:1:{s:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\";a:1:{i:0;O:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\":1:{s:55:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\";s:21:\\"messenger.bus.default\\";}}}s:45:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\";O:51:\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\":2:{s:60:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\";O:39:\\"Symfony\\\\Bridge\\\\Twig\\\\Mime\\\\TemplatedEmail\\":5:{i:0;s:41:\\"registration/confirmation_email.html.twig\\";i:1;N;i:2;a:3:{s:9:\\"signedUrl\\";s:178:\\"http://127.0.0.1:8000/email/verified?expires=1734193020&id=108&signature=Q4mtpHb4Dka5TVmgW9gY7mGlnlyZnWZ7W%2FXdhdOpBns%3D&token=Bwisfojxgo9NjdFi4o9%2FmQjz4UhM%2BU1mFvPJadUiI4c%3D\\";s:19:\\"expiresAtMessageKey\\";s:26:\\"%count% hour|%count% hours\\";s:20:\\"expiresAtMessageData\\";a:1:{s:7:\\"%count%\\";i:1;}}i:3;a:6:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;a:0:{}i:5;a:2:{i:0;O:37:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\":2:{s:46:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\";a:3:{s:4:\\"from\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:4:\\"From\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:22:\\"mailgun@CourseSite.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:2:\\"to\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:2:\\"To\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:11:\\"asdas@wp.pl\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:7:\\"subject\\";a:1:{i:0;O:48:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:7:\\"Subject\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:55:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\";s:25:\\"Please Confirm your Email\\";}}}s:49:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\";i:76;}i:1;N;}}i:4;N;}s:61:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\";N;}}	[]	default	2024-12-14 15:17:00	2024-12-14 15:17:00	\N
5	O:36:\\"Symfony\\\\Component\\\\Messenger\\\\Envelope\\":2:{s:44:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0stamps\\";a:1:{s:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\";a:1:{i:0;O:46:\\"Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\":1:{s:55:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Stamp\\\\BusNameStamp\\0busName\\";s:21:\\"messenger.bus.default\\";}}}s:45:\\"\\0Symfony\\\\Component\\\\Messenger\\\\Envelope\\0message\\";O:51:\\"Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\":2:{s:60:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0message\\";O:39:\\"Symfony\\\\Bridge\\\\Twig\\\\Mime\\\\TemplatedEmail\\":5:{i:0;s:41:\\"registration/confirmation_email.html.twig\\";i:1;N;i:2;a:3:{s:9:\\"signedUrl\\";s:180:\\"http://127.0.0.1:8000/email/verified?expires=1734193054&id=109&signature=T0PX4c%2BFs4NK64aKhluT4Mej53KmJjF0gpJq1npaJRA%3D&token=kdQr2%2B0T%2B9Yt3FuEsNZW117dbvfeDZNtjSjfYpWU%2FQk%3D\\";s:19:\\"expiresAtMessageKey\\";s:26:\\"%count% hour|%count% hours\\";s:20:\\"expiresAtMessageData\\";a:1:{s:7:\\"%count%\\";i:1;}}i:3;a:6:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;a:0:{}i:5;a:2:{i:0;O:37:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\":2:{s:46:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0headers\\";a:3:{s:4:\\"from\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:4:\\"From\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:22:\\"mailgun@CourseSite.com\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:2:\\"to\\";a:1:{i:0;O:47:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:2:\\"To\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:58:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\MailboxListHeader\\0addresses\\";a:1:{i:0;O:30:\\"Symfony\\\\Component\\\\Mime\\\\Address\\":2:{s:39:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0address\\";s:11:\\"sz425@wp.pl\\";s:36:\\"\\0Symfony\\\\Component\\\\Mime\\\\Address\\0name\\";s:0:\\"\\";}}}}s:7:\\"subject\\";a:1:{i:0;O:48:\\"Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\":5:{s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0name\\";s:7:\\"Subject\\";s:56:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lineLength\\";i:76;s:50:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0lang\\";N;s:53:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\AbstractHeader\\0charset\\";s:5:\\"utf-8\\";s:55:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\UnstructuredHeader\\0value\\";s:25:\\"Please Confirm your Email\\";}}}s:49:\\"\\0Symfony\\\\Component\\\\Mime\\\\Header\\\\Headers\\0lineLength\\";i:76;}i:1;N;}}i:4;N;}s:61:\\"\\0Symfony\\\\Component\\\\Mailer\\\\Messenger\\\\SendEmailMessage\\0envelope\\";N;}}	[]	default	2024-12-14 15:17:34	2024-12-14 15:17:34	\N
\.


--
-- TOC entry 4942 (class 0 OID 16735)
-- Dependencies: 234
-- Data for Name: rating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rating (id, user_id, course_id, value, message) FROM stdin;
\.


--
-- TOC entry 4943 (class 0 OID 16743)
-- Dependencies: 235
-- Data for Name: reset_password_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reset_password_request (id, user_id, selector, hashed_token, requested_at, expires_at) FROM stdin;
\.


--
-- TOC entry 4944 (class 0 OID 16749)
-- Dependencies: 236
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, roles, password, email, is_verified, public_image_id, image_path) FROM stdin;
85	ubechtelar	["ROLE_USER"]	$2y$13$yv21b7ZQlFfSpiCi5yHwv.CU/kZNErMQYeXBUn9zSTDsq3FuPz1a.	jonatan.reilly@gmail.com	t	\N	\N
86	rsmitham	["ROLE_USER"]	$2y$13$lwzVUasNHgmpWp3V/D0taeF93LC0Cx1SX29sDbycbzg43fn5h3AFy	lynch.katelynn@hotmail.com	t	\N	\N
87	koch.roxane	["ROLE_USER"]	$2y$13$NR8t5WJWfjqY67Gwil0sdO4h9ZbqsJ1S2gcv/qZEYMmUsCl4Bgrb6	gennaro.kirlin@yahoo.com	t	\N	\N
88	mitchel.oberbrunner	["ROLE_USER"]	$2y$13$TXV41pQrz21Se.6VMKrhv.ykGg3.bo.36I2gYpiBU6HoFa6Ey6fyi	sedrick.hodkiewicz@lubowitz.org	t	\N	\N
89	hilpert.rebeka	["ROLE_USER"]	$2y$13$E6aCEDFq7tjgZ7GWhMAhO.XdX7ITftbDFrRa6b7e5NqNcWWDdcyky	ebba52@cormier.com	t	\N	\N
90	evert11	["ROLE_USER"]	$2y$13$kApM/KNef7dHbiVfba9BQutoZIXGWiTSO2F6eEgGkh0XNHnvHD1ea	mario.schaden@wuckert.com	t	\N	\N
91	lmetz	["ROLE_USER"]	$2y$13$CpU1gYMyt5afDO.N5CTqYucQQhKWsN9/YosQQ1HsTSLJALdeJHG.6	noemy57@yahoo.com	t	\N	\N
92	johan11	["ROLE_USER"]	$2y$13$xBWvlUiQt4AJ4trARzJnoukqoiZxNLXB/mQ7nyWpgDfv8qPV4X6Om	jarod85@yahoo.com	t	\N	\N
93	valerie.bradtke	["ROLE_USER"]	$2y$13$3ZBmpel2rz/wa53xb24dieWo4VvhK682sdwTJMD/NrLvb6Tw6kem2	vfisher@pacocha.net	t	\N	\N
94	dframi	["ROLE_USER"]	$2y$13$1T.hYh/O4n49mepmTP4P5erQ6HL6IFc8efxIgnYvPlC/7N2ZoW6uK	eileen.larson@yahoo.com	t	\N	\N
95	ali.hintz	["ROLE_USER"]	$2y$13$XMAHpZuveDYbbmnUmSDEB.ltmtCWeyN/YzykI8vPCNnppUdJ5ue6K	zboyle@gmail.com	t	\N	\N
96	wdare	["ROLE_USER"]	$2y$13$ZRMyii9IOX5QjNohJxJCc.gRfN/FUC5xFIRd13F.JMziRUeIYaiRW	tstanton@koch.com	t	\N	\N
97	minnie32	["ROLE_USER"]	$2y$13$edPNjI/JvsQxFIZxwRdl8.QUtY00sJ8iJmG2O6cpaPh5wd72vFOiG	treutel.edgar@bartoletti.net	t	\N	\N
98	smitham.brionna	["ROLE_USER"]	$2y$13$n/DXB.VKfqcovImNIFjNqunEfWLMrJR/HbbeJ0OTYpNRoa6sCvpTG	harber.kurtis@gmail.com	t	\N	\N
99	esperanza54	["ROLE_USER"]	$2y$13$a/0wOkYfL9n.BhipBvvqyOo8xXB1q.q7NW0hd2ExQduqhxZuPJUQC	curt.hettinger@king.com	t	\N	\N
100	odessa.hahn	["ROLE_USER"]	$2y$13$uMwuWJzMTbHlNG3l3ZXEL.o59vmgsnpOdHxGJScnQe6XST9fpVRMG	zwilliamson@yahoo.com	t	\N	\N
101	carroll.delilah	["ROLE_USER"]	$2y$13$o3ADjG6H38SMNOYpJX7GfuQ6zjwBK5oXlvxicRkD/hBOqhL/UQC6C	kelvin13@hotmail.com	t	\N	\N
102	ratke.moriah	["ROLE_USER"]	$2y$13$7LDn8.FpL83VjBUZCF0neeUdqW5787Eb1ZUVkkwUq62C2mYN3rzAC	lloyd13@schmeler.net	t	\N	\N
103	tcarroll	["ROLE_USER"]	$2y$13$ZxiB1JjaXvBxXe0Wa68AQunifIoaY7aRWRbbV27cDTEQ0Z.1Xktx6	roberts.deondre@leannon.com	t	\N	\N
104	kweissnat	["ROLE_USER"]	$2y$13$igZnUurlQAHVUnNGsfpuPuYnajhXSSJ7ijCQZmTt1kE8YSWgoD6kS	katelynn.kertzmann@yahoo.com	t	\N	\N
105	Admin	["ROLE_ADMIN"]	$2y$13$7XkUftdmiS.v1APysqZdkuYJ5FS.dvr6/gZZrGbZAAm0xezHXVAFm	admin@email.com	t	\N	\N
106	Szymon	["ROLE_USER"]	$2y$13$p9lVVaOhX44A0BztJ1efmem6uE.0ciBdNM9gYdc5h7PAhjCe3HEfG	sz425@outlook.com	f	\N	\N
107	szympon12	["ROLE_USER"]	$2y$13$fJFNWYn.zJW8Aj.5I/bKSurKxGBY.eOzShl0pm98cZvIBSJrVrMzi	sz425@wp.pl	f	\N	\N
108	asdasd	["ROLE_USER"]	$2y$13$XdVqPkM868c4RgBIbHW13.4exS05k/YVxqKCqFiSPc79VfeyK/im.	asdas@wp.pl	f	\N	\N
109	szzsdasd	["ROLE_USER"]	$2y$13$8ir2qveyhTGpB8nHAqxrzOlNqS1LIaVN6Vf1vSA2rcgBaojjWZ1nq	sz425@wp.pl	f	\N	\N
\.


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 216
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_id_seq', 109, true);


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 217
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 325, true);


--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 219
-- Name: chapter_draft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chapter_draft_id_seq', 500, true);


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 218
-- Name: chapter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chapter_id_seq', 500, true);


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 221
-- Name: episode_draft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.episode_draft_id_seq', 1500, true);


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 220
-- Name: episode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.episode_id_seq', 1500, true);


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 237
-- Name: messenger_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messenger_messages_id_seq', 5, true);


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 222
-- Name: rating_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rating_id_seq', 1, false);


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 223
-- Name: reset_password_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reset_password_request_id_seq', 1, false);


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 224
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 109, true);


--
-- TOC entry 4723 (class 2606 OID 16666)
-- Name: cart_course cart_course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_course
    ADD CONSTRAINT cart_course_pkey PRIMARY KEY (cart_id, course_id);


--
-- TOC entry 4720 (class 2606 OID 16660)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- TOC entry 4727 (class 2606 OID 16673)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 4733 (class 2606 OID 16685)
-- Name: chapter_draft chapter_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chapter_draft
    ADD CONSTRAINT chapter_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 4730 (class 2606 OID 16679)
-- Name: chapter chapter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chapter
    ADD CONSTRAINT chapter_pkey PRIMARY KEY (id);


--
-- TOC entry 4741 (class 2606 OID 16707)
-- Name: course_draft course_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_draft
    ADD CONSTRAINT course_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 4736 (class 2606 OID 16695)
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- TOC entry 4718 (class 2606 OID 16645)
-- Name: doctrine_migration_versions doctrine_migration_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctrine_migration_versions
    ADD CONSTRAINT doctrine_migration_versions_pkey PRIMARY KEY (version);


--
-- TOC entry 4747 (class 2606 OID 16733)
-- Name: episode_draft episode_draft_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.episode_draft
    ADD CONSTRAINT episode_draft_pkey PRIMARY KEY (id);


--
-- TOC entry 4744 (class 2606 OID 16720)
-- Name: episode episode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.episode
    ADD CONSTRAINT episode_pkey PRIMARY KEY (id);


--
-- TOC entry 4763 (class 2606 OID 16768)
-- Name: messenger_messages messenger_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messenger_messages
    ADD CONSTRAINT messenger_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 4752 (class 2606 OID 16740)
-- Name: rating rating_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT rating_pkey PRIMARY KEY (id);


--
-- TOC entry 4755 (class 2606 OID 16747)
-- Name: reset_password_request reset_password_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_password_request
    ADD CONSTRAINT reset_password_request_pkey PRIMARY KEY (id);


--
-- TOC entry 4758 (class 2606 OID 16757)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4737 (class 1259 OID 16698)
-- Name: idx_169e6fb912469de2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_169e6fb912469de2 ON public.course USING btree (category_id);


--
-- TOC entry 4738 (class 1259 OID 16697)
-- Name: idx_169e6fb9a76ed395; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_169e6fb9a76ed395 ON public.course USING btree (user_id);


--
-- TOC entry 4724 (class 1259 OID 16667)
-- Name: idx_181a0de61ad5cdbf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_181a0de61ad5cdbf ON public.cart_course USING btree (cart_id);


--
-- TOC entry 4725 (class 1259 OID 16668)
-- Name: idx_181a0de6591cc992; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_181a0de6591cc992 ON public.cart_course USING btree (course_id);


--
-- TOC entry 4728 (class 1259 OID 16674)
-- Name: idx_64c19c1727aca70; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_64c19c1727aca70 ON public.category USING btree (parent_id);


--
-- TOC entry 4759 (class 1259 OID 16771)
-- Name: idx_75ea56e016ba31db; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_75ea56e016ba31db ON public.messenger_messages USING btree (delivered_at);


--
-- TOC entry 4760 (class 1259 OID 16770)
-- Name: idx_75ea56e0e3bd61ce; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_75ea56e0e3bd61ce ON public.messenger_messages USING btree (available_at);


--
-- TOC entry 4761 (class 1259 OID 16769)
-- Name: idx_75ea56e0fb7336f0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_75ea56e0fb7336f0 ON public.messenger_messages USING btree (queue_name);


--
-- TOC entry 4753 (class 1259 OID 16748)
-- Name: idx_7ce748aa76ed395; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_7ce748aa76ed395 ON public.reset_password_request USING btree (user_id);


--
-- TOC entry 4748 (class 1259 OID 16734)
-- Name: idx_7d7660c04eaa8d4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_7d7660c04eaa8d4 ON public.episode_draft USING btree (chapter_draft_id);


--
-- TOC entry 4742 (class 1259 OID 16708)
-- Name: idx_afd7917c12469de2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_afd7917c12469de2 ON public.course_draft USING btree (category_id);


--
-- TOC entry 4721 (class 1259 OID 16661)
-- Name: idx_ba388b7a76ed395; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ba388b7a76ed395 ON public.cart USING btree (user_id);


--
-- TOC entry 4734 (class 1259 OID 16686)
-- Name: idx_c635002b4b47a887; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_c635002b4b47a887 ON public.chapter_draft USING btree (course_draft_id);


--
-- TOC entry 4749 (class 1259 OID 16742)
-- Name: idx_d8892622591cc992; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_d8892622591cc992 ON public.rating USING btree (course_id);


--
-- TOC entry 4750 (class 1259 OID 16741)
-- Name: idx_d8892622a76ed395; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_d8892622a76ed395 ON public.rating USING btree (user_id);


--
-- TOC entry 4745 (class 1259 OID 16721)
-- Name: idx_ddaa1cda579f4768; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ddaa1cda579f4768 ON public.episode USING btree (chapter_id);


--
-- TOC entry 4731 (class 1259 OID 16680)
-- Name: idx_f981b52e591cc992; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_f981b52e591cc992 ON public.chapter USING btree (course_id);


--
-- TOC entry 4739 (class 1259 OID 16696)
-- Name: uniq_169e6fb94b47a887; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_169e6fb94b47a887 ON public.course USING btree (course_draft_id);


--
-- TOC entry 4756 (class 1259 OID 16758)
-- Name: uniq_identifier_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_identifier_username ON public.users USING btree (username);


--
-- TOC entry 4779 (class 2620 OID 16773)
-- Name: messenger_messages notify_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notify_trigger AFTER INSERT OR UPDATE ON public.messenger_messages FOR EACH ROW EXECUTE FUNCTION public.notify_messenger_messages();


--
-- TOC entry 4770 (class 2606 OID 16814)
-- Name: course fk_169e6fb912469de2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT fk_169e6fb912469de2 FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- TOC entry 4771 (class 2606 OID 16804)
-- Name: course fk_169e6fb94b47a887; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT fk_169e6fb94b47a887 FOREIGN KEY (course_draft_id) REFERENCES public.course_draft(id);


--
-- TOC entry 4772 (class 2606 OID 16809)
-- Name: course fk_169e6fb9a76ed395; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT fk_169e6fb9a76ed395 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4765 (class 2606 OID 16779)
-- Name: cart_course fk_181a0de61ad5cdbf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_course
    ADD CONSTRAINT fk_181a0de61ad5cdbf FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON DELETE CASCADE;


--
-- TOC entry 4766 (class 2606 OID 16784)
-- Name: cart_course fk_181a0de6591cc992; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_course
    ADD CONSTRAINT fk_181a0de6591cc992 FOREIGN KEY (course_id) REFERENCES public.course(id) ON DELETE CASCADE;


--
-- TOC entry 4767 (class 2606 OID 16789)
-- Name: category fk_64c19c1727aca70; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT fk_64c19c1727aca70 FOREIGN KEY (parent_id) REFERENCES public.category(id);


--
-- TOC entry 4778 (class 2606 OID 16844)
-- Name: reset_password_request fk_7ce748aa76ed395; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_password_request
    ADD CONSTRAINT fk_7ce748aa76ed395 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4775 (class 2606 OID 16829)
-- Name: episode_draft fk_7d7660c04eaa8d4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.episode_draft
    ADD CONSTRAINT fk_7d7660c04eaa8d4 FOREIGN KEY (chapter_draft_id) REFERENCES public.chapter_draft(id);


--
-- TOC entry 4773 (class 2606 OID 16819)
-- Name: course_draft fk_afd7917c12469de2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_draft
    ADD CONSTRAINT fk_afd7917c12469de2 FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- TOC entry 4764 (class 2606 OID 16774)
-- Name: cart fk_ba388b7a76ed395; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT fk_ba388b7a76ed395 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4769 (class 2606 OID 16799)
-- Name: chapter_draft fk_c635002b4b47a887; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chapter_draft
    ADD CONSTRAINT fk_c635002b4b47a887 FOREIGN KEY (course_draft_id) REFERENCES public.course_draft(id);


--
-- TOC entry 4776 (class 2606 OID 16839)
-- Name: rating fk_d8892622591cc992; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT fk_d8892622591cc992 FOREIGN KEY (course_id) REFERENCES public.course(id);


--
-- TOC entry 4777 (class 2606 OID 16834)
-- Name: rating fk_d8892622a76ed395; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating
    ADD CONSTRAINT fk_d8892622a76ed395 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4774 (class 2606 OID 16824)
-- Name: episode fk_ddaa1cda579f4768; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.episode
    ADD CONSTRAINT fk_ddaa1cda579f4768 FOREIGN KEY (chapter_id) REFERENCES public.chapter(id);


--
-- TOC entry 4768 (class 2606 OID 16794)
-- Name: chapter fk_f981b52e591cc992; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chapter
    ADD CONSTRAINT fk_f981b52e591cc992 FOREIGN KEY (course_id) REFERENCES public.course(id);


-- Completed on 2024-12-15 11:05:02

--
-- PostgreSQL database dump complete
--

