--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 16.6

-- Started on 2025-05-12 04:23:57 UTC

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
-- TOC entry 215 (class 1259 OID 16704)
-- Name: app_user; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.app_user (
    enabled boolean NOT NULL,
    password character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    app_user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id uuid
);


ALTER TABLE public.app_user OWNER TO myuser;

--
-- TOC entry 216 (class 1259 OID 16710)
-- Name: attachments; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.attachments (
    attachment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path text NOT NULL,
    file_size bigint NOT NULL,
    upload_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    uploaded_by bigint,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.attachments OWNER TO myuser;

--
-- TOC entry 217 (class 1259 OID 16718)
-- Name: available_roles; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.available_roles (
    role_name character varying(255) NOT NULL,
    role_id integer
);


ALTER TABLE public.available_roles OWNER TO myuser;

--
-- TOC entry 218 (class 1259 OID 16721)
-- Name: checklistitems; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.checklistitems (
    checklist_item_id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    item_text character varying(255) NOT NULL,
    is_completed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.checklistitems OWNER TO myuser;

--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE checklistitems; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.checklistitems IS 'Các mục cần kiểm tra để hoàn thành một công việc.';


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN checklistitems.checklist_item_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.checklistitems.checklist_item_id IS 'Khóa chính duy nhất (UUID) của bảng ChecklistItems.';


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN checklistitems.task_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.checklistitems.task_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Tasks.';


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN checklistitems.item_text; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.checklistitems.item_text IS 'Nội dung của mục kiểm tra.';


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN checklistitems.is_completed; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.checklistitems.is_completed IS 'Trạng thái của mục kiểm tra (true: đã hoàn thành, false: chưa hoàn thành).';


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN checklistitems.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.checklistitems.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN checklistitems.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.checklistitems.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 219 (class 1259 OID 16727)
-- Name: default_stages; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.default_stages (
    default_stage_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_type_id uuid NOT NULL,
    stage_name character varying(100) NOT NULL,
    description text,
    order_number integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.default_stages OWNER TO myuser;

--
-- TOC entry 220 (class 1259 OID 16734)
-- Name: departments; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.departments (
    department_id uuid DEFAULT gen_random_uuid() NOT NULL,
    department_name character varying(100) NOT NULL,
    description text,
    location character varying(255)
);


ALTER TABLE public.departments OWNER TO myuser;

--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE departments; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.departments IS 'Thông tin về các phòng ban trong tổ chức.';


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN departments.department_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.departments.department_id IS 'Khóa chính duy nhất (UUID) của bảng Departments.';


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN departments.department_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.departments.department_name IS 'Tên của phòng ban (duy nhất).';


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN departments.description; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.departments.description IS 'Mô tả về phòng ban.';


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN departments.location; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.departments.location IS 'Địa điểm của phòng ban.';


--
-- TOC entry 221 (class 1259 OID 16740)
-- Name: employees; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.employees (
    employee_id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone_number character varying(20),
    hire_date date NOT NULL,
    job_title character varying(100) NOT NULL,
    department_id uuid,
    manager_id uuid,
    salary numeric(10,2),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone,
    job_title_id uuid,
    username character varying(255),
    active boolean DEFAULT true NOT NULL,
    app_user_id uuid
);


ALTER TABLE public.employees OWNER TO myuser;

--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE employees; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.employees IS 'Thông tin về các nhân viên.';


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.employee_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.employee_id IS 'Khóa chính duy nhất (UUID) của bảng Employees.';


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.first_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.first_name IS 'Tên đầu của nhân viên.';


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.last_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.last_name IS 'Họ của nhân viên.';


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.email; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.email IS 'Địa chỉ email của nhân viên (duy nhất).';


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.phone_number; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.phone_number IS 'Số điện thoại của nhân viên.';


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.hire_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.hire_date IS 'Ngày nhân viên được tuyển dụng.';


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.job_title; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.job_title IS 'Chức danh công việc của nhân viên.';


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.department_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.department_id IS 'Khóa ngoại (UUID) liên kết đến bảng Departments.';


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.manager_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.manager_id IS 'Khóa ngoại (UUID) tham chiếu đến employee_id của người quản lý (có thể là NULL).';


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.salary; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.salary IS 'Mức lương của nhân viên.';


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN employees.job_title_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.employees.job_title_id IS 'Khóa ngoại (UUID) liên kết đến bảng JobTitles, xác định chức vụ công việc chính của nhân viên.';


--
-- TOC entry 222 (class 1259 OID 16748)
-- Name: job_title_roles; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.job_title_roles (
    job_title_id uuid NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE public.job_title_roles OWNER TO myuser;

--
-- TOC entry 223 (class 1259 OID 16751)
-- Name: jobtitles; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.jobtitles (
    job_title_id uuid DEFAULT gen_random_uuid() NOT NULL,
    job_title_name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.jobtitles OWNER TO myuser;

--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE jobtitles; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.jobtitles IS 'Danh sách các chức vụ công việc khác nhau.';


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN jobtitles.job_title_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.jobtitles.job_title_id IS 'Khóa chính duy nhất (UUID) của bảng JobTitles.';


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN jobtitles.job_title_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.jobtitles.job_title_name IS 'Tên của chức vụ công việc (duy nhất). Ví dụ: Trưởng phòng, Chuyên viên, Nhân viên.';


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN jobtitles.description; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.jobtitles.description IS 'Mô tả chi tiết về chức vụ công việc.';


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN jobtitles.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.jobtitles.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN jobtitles.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.jobtitles.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 224 (class 1259 OID 16758)
-- Name: meetings; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.meetings (
    meeting_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    meeting_name character varying(255) NOT NULL,
    meeting_date timestamp with time zone NOT NULL,
    duration_minutes integer NOT NULL,
    location character varying(255),
    agenda text,
    attendees text,
    minutes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.meetings OWNER TO myuser;

--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE meetings; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.meetings IS 'Các cuộc họp liên quan đến dự án.';


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.meeting_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.meeting_id IS 'Khóa chính duy nhất (UUID) của bảng Meetings.';


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.project_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.project_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Projects.';


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.meeting_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.meeting_name IS 'Tên cuộc họp.';


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.meeting_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.meeting_date IS 'Thời gian bắt đầu cuộc họp.';


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.duration_minutes; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.duration_minutes IS 'Thời lượng cuộc họp (phút).';


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.location; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.location IS 'Địa điểm cuộc họp.';


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.agenda; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.agenda IS 'Nội dung cuộc họp.';


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.attendees; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.attendees IS 'Danh sách người tham gia cuộc họp.';


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.minutes; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.minutes IS 'Biên bản cuộc họp.';


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 224
-- Name: COLUMN meetings.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.meetings.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 225 (class 1259 OID 16765)
-- Name: notifications; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.notifications (
    notification_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id bigint NOT NULL,
    notification_type character varying(255) NOT NULL,
    source_id uuid,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.notifications OWNER TO myuser;

--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE notifications; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.notifications IS 'Các thông báo liên quan đến dự án.';


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.notification_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.notification_id IS 'Khóa chính duy nhất (UUID) của bảng Notifications.';


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.user_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.user_id IS 'Khóa ngoại (BIGINT) tham chiếu đến bảng public.app_user, người nhận thông báo.';


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.notification_type; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.notification_type IS 'Loại thông báo.';


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.source_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.source_id IS 'ID của đối tượng liên quan (ví dụ: task_id, project_id).';


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.message; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.message IS 'Nội dung thông báo.';


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.is_read; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.is_read IS 'Trạng thái đã đọc của thông báo.';


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN notifications.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.notifications.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 226 (class 1259 OID 16773)
-- Name: projectmembers; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.projectmembers (
    project_id uuid NOT NULL,
    employee_id uuid NOT NULL,
    role character varying(100),
    join_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.projectmembers OWNER TO myuser;

--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE projectmembers; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.projectmembers IS 'Quan hệ giữa nhân viên và các dự án mà họ tham gia, cùng với vai trò của họ.';


--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN projectmembers.project_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmembers.project_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Projects.';


--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN projectmembers.employee_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmembers.employee_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Employees.';


--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN projectmembers.role; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmembers.role IS 'Vai trò của nhân viên trong dự án.';


--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN projectmembers.join_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmembers.join_date IS 'Ngày nhân viên tham gia dự án.';


--
-- TOC entry 227 (class 1259 OID 16777)
-- Name: projectmilestones; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.projectmilestones (
    milestone_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    milestone_name character varying(255) NOT NULL,
    milestone_date date NOT NULL,
    description text,
    is_completed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.projectmilestones OWNER TO myuser;

--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE projectmilestones; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.projectmilestones IS 'Các mốc quan trọng của dự án.';


--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.milestone_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.milestone_id IS 'Khóa chính duy nhất (UUID) của bảng ProjectMilestones.';


--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.project_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.project_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Projects.';


--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.milestone_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.milestone_name IS 'Tên mốc quan trọng.';


--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.milestone_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.milestone_date IS 'Ngày dự kiến đạt mốc quan trọng.';


--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.description; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.description IS 'Mô tả về mốc quan trọng.';


--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.is_completed; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.is_completed IS 'Trạng thái hoàn thành của mốc quan trọng.';


--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN projectmilestones.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectmilestones.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 228 (class 1259 OID 16785)
-- Name: projects; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.projects (
    project_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_name character varying(255) NOT NULL,
    description text,
    start_date date,
    end_date date,
    status character varying(50) DEFAULT 'New'::character varying,
    priority character varying(50),
    manager_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone,
    project_type_id uuid
);


ALTER TABLE public.projects OWNER TO myuser;

--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE projects; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.projects IS 'Thông tin về các dự án.';


--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.project_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.project_id IS 'Khóa chính duy nhất (UUID) của bảng Projects.';


--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.project_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.project_name IS 'Tên của dự án.';


--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.description; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.description IS 'Mô tả về dự án.';


--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.start_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.start_date IS 'Ngày bắt đầu dự án.';


--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.end_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.end_date IS 'Ngày kết thúc dự án (dự kiến).';


--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.status; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.status IS 'Trạng thái hiện tại của dự án.';


--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.priority; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.priority IS 'Mức độ ưu tiên của dự án.';


--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.manager_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.manager_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Employees, người quản lý dự án.';


--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN projects.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projects.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 229 (class 1259 OID 16793)
-- Name: projectstages; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.projectstages (
    stage_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid NOT NULL,
    stage_name character varying(100) NOT NULL,
    description text,
    start_date date,
    end_date date,
    status character varying(50) DEFAULT 'To Do'::character varying,
    order_number integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.projectstages OWNER TO myuser;

--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE projectstages; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.projectstages IS 'Thông tin về các giai đoạn của dự án.';


--
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.stage_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.stage_id IS 'Khóa chính duy nhất (UUID) của bảng ProjectStages.';


--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.project_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.project_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Projects.';


--
-- TOC entry 3665 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.stage_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.stage_name IS 'Tên của giai đoạn dự án.';


--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.description; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.description IS 'Mô tả về giai đoạn dự án.';


--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.start_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.start_date IS 'Ngày bắt đầu giai đoạn (dự kiến).';


--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.end_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.end_date IS 'Ngày kết thúc giai đoạn (dự kiến).';


--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.status; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.status IS 'Trạng thái hiện tại của giai đoạn.';


--
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.order_number; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.order_number IS 'Thứ tự của giai đoạn trong dự án.';


--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 229
-- Name: COLUMN projectstages.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.projectstages.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 230 (class 1259 OID 16801)
-- Name: projecttypes; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.projecttypes (
    project_type_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_type_name character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.projecttypes OWNER TO myuser;

--
-- TOC entry 236 (class 1259 OID 17036)
-- Name: projectworks; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.projectworks (
    work_id uuid DEFAULT gen_random_uuid() NOT NULL,
    work_name character varying(255) NOT NULL,
    description text,
    start_date date,
    end_date date,
    status character varying(50) DEFAULT 'To Do'::character varying,
    priority character varying(50),
    project_id uuid NOT NULL,
    stage_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.projectworks OWNER TO myuser;

--
-- TOC entry 231 (class 1259 OID 16808)
-- Name: taskcomments; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.taskcomments (
    comment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    user_id bigint NOT NULL,
    comment_text text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.taskcomments OWNER TO myuser;

--
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE taskcomments; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.taskcomments IS 'Các bình luận liên quan đến một công việc.';


--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN taskcomments.comment_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskcomments.comment_id IS 'Khóa chính duy nhất (UUID) của bảng TaskComments.';


--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN taskcomments.task_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskcomments.task_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Tasks.';


--
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN taskcomments.user_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskcomments.user_id IS 'Khóa ngoại (BIGINT) tham chiếu đến bảng public.app_user, người viết bình luận.';


--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN taskcomments.comment_text; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskcomments.comment_text IS 'Nội dung của bình luận.';


--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN taskcomments.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskcomments.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN taskcomments.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskcomments.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 232 (class 1259 OID 16815)
-- Name: taskdependencies; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.taskdependencies (
    dependency_id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    depends_on_task_id uuid NOT NULL,
    dependency_type character varying(50) DEFAULT 'Finish-to-Start'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.taskdependencies OWNER TO myuser;

--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE taskdependencies; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.taskdependencies IS 'Mô tả mối quan hệ phụ thuộc giữa các công việc.';


--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN taskdependencies.dependency_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskdependencies.dependency_id IS 'Khóa chính duy nhất (UUID) của bảng TaskDependencies.';


--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN taskdependencies.task_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskdependencies.task_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Tasks, công việc phụ thuộc.';


--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN taskdependencies.depends_on_task_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskdependencies.depends_on_task_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Tasks, công việc mà task_id phụ thuộc vào.';


--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN taskdependencies.dependency_type; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskdependencies.dependency_type IS 'Loại quan hệ phụ thuộc.';


--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN taskdependencies.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskdependencies.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN taskdependencies.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskdependencies.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 233 (class 1259 OID 16821)
-- Name: taskprogresschecklistitems; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.taskprogresschecklistitems (
    progress_update_id uuid NOT NULL,
    checklist_item_id uuid NOT NULL,
    is_checked boolean NOT NULL
);


ALTER TABLE public.taskprogresschecklistitems OWNER TO myuser;

--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE taskprogresschecklistitems; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.taskprogresschecklistitems IS 'Lưu trữ trạng thái của các mục trong checklist của công việc trong mỗi lần cập nhật tiến độ.';


--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN taskprogresschecklistitems.progress_update_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogresschecklistitems.progress_update_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng TaskProgressUpdates.';


--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN taskprogresschecklistitems.checklist_item_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogresschecklistitems.checklist_item_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng ChecklistItems.';


--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN taskprogresschecklistitems.is_checked; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogresschecklistitems.is_checked IS 'Trạng thái của mục checklist trong lần cập nhật tiến độ này.';


--
-- TOC entry 234 (class 1259 OID 16824)
-- Name: taskprogressupdates; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.taskprogressupdates (
    progress_update_id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid NOT NULL,
    updated_by bigint,
    update_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    new_status character varying(50),
    comment text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone
);


ALTER TABLE public.taskprogressupdates OWNER TO myuser;

--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE taskprogressupdates; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.taskprogressupdates IS 'Lưu trữ thông tin về các lần cập nhật tiến độ của một công việc.';


--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.progress_update_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.progress_update_id IS 'Khóa chính duy nhất (UUID) của bảng TaskProgressUpdates.';


--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.task_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.task_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Tasks.';


--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.updated_by; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.updated_by IS 'Khóa ngoại (BIGINT) tham chiếu đến bảng public.app_user, người thực hiện cập nhật.';


--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.update_time; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.update_time IS 'Thời điểm cập nhật tiến độ.';


--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.new_status; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.new_status IS 'Trạng thái mới của công việc sau khi cập nhật.';


--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.comment; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.comment IS 'Bình luận về lần cập nhật tiến độ này.';


--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN taskprogressupdates.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.taskprogressupdates.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 235 (class 1259 OID 16832)
-- Name: tasks; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.tasks (
    task_id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    stage_id uuid,
    task_name character varying(255) NOT NULL,
    description text,
    start_date date,
    due_date date,
    status character varying(50) DEFAULT 'To Do'::character varying,
    priority character varying(50),
    assignee_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone,
    work_id uuid NOT NULL
);


ALTER TABLE public.tasks OWNER TO myuser;

--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE tasks; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON TABLE public.tasks IS 'Thông tin về các công việc trong dự án.';


--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.task_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.task_id IS 'Khóa chính duy nhất (UUID) của bảng Tasks.';


--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.project_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.project_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Projects.';


--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.stage_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.stage_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng ProjectStages.';


--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.task_name; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.task_name IS 'Tên của công việc.';


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.description; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.description IS 'Mô tả về công việc.';


--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.start_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.start_date IS 'Ngày bắt đầu công việc (dự kiến).';


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.due_date; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.due_date IS 'Ngày hoàn thành công việc (dự kiến).';


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.status; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.status IS 'Trạng thái hiện tại của công việc.';


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.priority; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.priority IS 'Mức độ ưu tiên của công việc.';


--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.assignee_id; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.assignee_id IS 'Khóa ngoại (UUID) tham chiếu đến bảng Employees, người được giao công việc.';


--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.created_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.created_at IS 'Thời điểm bản ghi được tạo.';


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN tasks.updated_at; Type: COMMENT; Schema: public; Owner: myuser
--

COMMENT ON COLUMN public.tasks.updated_at IS 'Thời điểm bản ghi được cập nhật lần cuối.';


--
-- TOC entry 3557 (class 0 OID 16704)
-- Dependencies: 215
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.app_user VALUES (true, '$2a$10$GOSenQ80xUpEH5e49pRnQ.7cpX8.AaPdeI.6p/PZdBllc7WCwYQOW', 'admin', '7eb36ae8-e0e5-4748-89a6-a2bbbb046b9b', '16f1c827-eace-49ee-b22a-c049b7adaf7e');
INSERT INTO public.app_user VALUES (true, '$2a$10$Dg3CHXOnt7uTQIFkBOs.7O8Sl1izVga2xOvCiS/wqN5H2DGy7izZ.', 'tranquang', '84979142-6f22-405a-a9be-d79db3a352ad', 'cc3ea5ef-6594-4a69-b4d4-3a1f61b92c2d');
INSERT INTO public.app_user VALUES (true, '$2a$10$clH.JZHZPIL.Q9cFfv3TY.IvALJDdbl3iaFd1ULibXAATbR5o9vke', 'ngothaison', '4986ae62-f13f-4a34-9233-64b2731d0ba5', 'bb81a5ff-d843-4c89-aa6e-cd371731a4ad');
INSERT INTO public.app_user VALUES (true, '$2a$10$KZhMIrMrWZxQDqSKJt4rQ.ifah9rTNojSlI8BCfWsTHdAwd4LzVQC', 'thanhvan', '616af0dc-7618-4fa7-8680-fb34f1f5141b', '37130ea0-ae3f-4821-af2e-917cf83e24b5');
INSERT INTO public.app_user VALUES (true, '$2a$10$CLb6tsJliFIwepBZnUojhenzJhL7OEnDCf9j9MNB/9wkf07nFlDEe', 'thunguyet', 'd0646124-e4c3-49c3-a27c-740b372da730', 'ec063a6f-4ee1-4677-a6c6-0f9c2dd0b070');
INSERT INTO public.app_user VALUES (true, '$2a$10$zzsbFsMDVS0/99oc51c0y..JV6yFvfMQN0cfx9p9Q3I2mxP77Mtii', 'minhhang', '7b3f7917-3511-4099-a2db-e3756d6ad41c', '875e512e-3f81-4b40-9ea0-e9c6a306c54c');


--
-- TOC entry 3558 (class 0 OID 16710)
-- Dependencies: 216
-- Data for Name: attachments; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3559 (class 0 OID 16718)
-- Dependencies: 217
-- Data for Name: available_roles; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.available_roles VALUES ('ROLE_ADMIN', 100);
INSERT INTO public.available_roles VALUES ('ROLE_PROJECT_MANAGER', 80);
INSERT INTO public.available_roles VALUES ('ROLE_TEAM_LEADER', 60);
INSERT INTO public.available_roles VALUES ('ROLE_DEVELOPER', 40);
INSERT INTO public.available_roles VALUES ('ROLE_REPORTER', 20);
INSERT INTO public.available_roles VALUES ('ROLE_GUEST', 10);
INSERT INTO public.available_roles VALUES ('ROLE_USER', 30);


--
-- TOC entry 3560 (class 0 OID 16721)
-- Dependencies: 218
-- Data for Name: checklistitems; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3561 (class 0 OID 16727)
-- Dependencies: 219
-- Data for Name: default_stages; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.default_stages VALUES ('dab24bab-ec4e-4d5e-b52e-6ca944e0528c', '0fdf11a8-bdae-4d62-a374-e0fd3a107826', 'Thu thập yêu cầu', 'Thu thập và phân tích yêu cầu của khách hàng', 1, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('da571d6f-68e3-4baa-b11f-c12ec422d03a', '0fdf11a8-bdae-4d62-a374-e0fd3a107826', 'Thiết kế', 'Thiết kế kiến trúc và giao diện của phần mềm', 2, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('cffcc131-6ebf-4bf6-ab36-89ac4b673f49', '0fdf11a8-bdae-4d62-a374-e0fd3a107826', 'Phát triển', 'Viết mã và xây dựng phần mềm', 3, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('2833ce2c-516f-46ff-9191-e70205b34de6', '0fdf11a8-bdae-4d62-a374-e0fd3a107826', 'Kiểm thử', 'Kiểm tra chất lượng và chức năng của phần mềm', 4, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('47817151-1f06-458a-97cf-1ab0355e15c9', '0fdf11a8-bdae-4d62-a374-e0fd3a107826', 'Triển khai', 'Triển khai phần mềm lên môi trường sản xuất', 5, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('cdf0d692-4e42-4941-9d06-370e74b6ad16', '0fdf11a8-bdae-4d62-a374-e0fd3a107826', 'Bảo trì', 'Bảo trì và hỗ trợ sau triển khai', 6, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('bfcd45f7-7a8f-4fab-be3f-5dcf42442b0a', '4781e43c-50da-4022-a168-2b43ca74b936', 'Nghiên cứu thị trường', 'Nghiên cứu thị trường và đối thủ cạnh tranh', 1, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('41b2a596-f692-423c-a428-610e71c693db', '4781e43c-50da-4022-a168-2b43ca74b936', 'Lập kế hoạch', 'Lập kế hoạch chiến lược marketing', 2, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('406d79da-8572-40a0-b150-9b951ec8e717', '4781e43c-50da-4022-a168-2b43ca74b936', 'Triển khai chiến dịch', 'Triển khai các hoạt động marketing', 3, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('07c6adab-d574-4dc9-902a-f3ea07476f05', '4781e43c-50da-4022-a168-2b43ca74b936', 'Đo lường và phân tích', 'Đo lường hiệu quả và phân tích kết quả', 4, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('2e99760f-ed38-4d0c-abd4-98481439f44e', '4781e43c-50da-4022-a168-2b43ca74b936', 'Tối ưu hóa', 'Tối ưu hóa các chiến dịch marketing', 5, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('f974f673-074d-4434-aed1-5bd1418e750b', '582d6c44-e0e6-46c3-8e95-a3a017971072', 'Chuẩn bị mặt bằng', 'Chuẩn bị và giải phóng mặt bằng xây dựng', 1, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('589db475-391e-4c29-8e2a-267ca67d4b87', '582d6c44-e0e6-46c3-8e95-a3a017971072', 'Xây dựng móng', 'Xây dựng móng công trình', 2, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('db4686e3-7949-406f-a58a-8522f0112e9b', '582d6c44-e0e6-46c3-8e95-a3a017971072', 'Xây dựng phần thô', 'Xây dựng khung và tường công trình', 3, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('1d2a3fab-7f2f-418d-8a58-fc02877468fc', '582d6c44-e0e6-46c3-8e95-a3a017971072', 'Hoàn thiện', 'Hoàn thiện nội thất và ngoại thất', 4, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('e23a89bc-e6c7-4b91-9a72-e5a296662445', '582d6c44-e0e6-46c3-8e95-a3a017971072', 'Nghiệm thu và bàn giao', 'Nghiệm thu và bàn giao công trình', 5, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('cb520ddc-145c-496d-90b4-7ec468c761eb', '6fdc95dc-4ebf-4114-8cf3-39c451110d8b', 'Lên ý tưởng', 'Lên ý tưởng và chủ đề cho sự kiện', 1, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('0642c485-36cd-4604-9678-99d8de26e44b', '6fdc95dc-4ebf-4114-8cf3-39c451110d8b', 'Lập kế hoạch', 'Lập kế hoạch chi tiết cho sự kiện', 2, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('9b84f200-a6d2-49f8-b3a9-2239330124a4', '6fdc95dc-4ebf-4114-8cf3-39c451110d8b', 'Chuẩn bị', 'Chuẩn bị địa điểm, vật dụng và nhân sự', 3, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('aa6917c8-2e7e-43af-845e-4369fd492918', '6fdc95dc-4ebf-4114-8cf3-39c451110d8b', 'Tổ chức sự kiện', 'Tiến hành tổ chức sự kiện', 4, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('927f890d-8718-4392-bf9c-1a084ddc56d2', '6fdc95dc-4ebf-4114-8cf3-39c451110d8b', 'Đánh giá và kết thúc', 'Đánh giá kết quả và kết thúc sự kiện', 5, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('736f58ca-0535-45d9-8c1e-5b5f12e8d9a2', 'b72062a7-659f-4e0f-8a54-c68ec7357fae', 'Nghiên cứu cơ bản', 'Nghiên cứu các khái niệm và lý thuyết cơ bản', 1, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('dd20cd86-d123-4a53-9245-d8fdfb1131b1', 'b72062a7-659f-4e0f-8a54-c68ec7357fae', 'Phát triển ý tưởng', 'Phát triển và đánh giá các ý tưởng sản phẩm', 2, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('ca2e7723-7192-40ed-a86c-a437798443d4', 'b72062a7-659f-4e0f-8a54-c68ec7357fae', 'Thử nghiệm', 'Thử nghiệm và đánh giá tính khả thi của sản phẩm', 3, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('80540b2f-6c0e-4a4d-a619-ccee971f78ef', 'b72062a7-659f-4e0f-8a54-c68ec7357fae', 'Hoàn thiện', 'Hoàn thiện và chuẩn bị sản phẩm cho sản xuất', 4, '2025-05-04 01:28:31.649906+00', NULL);
INSERT INTO public.default_stages VALUES ('599b405d-f60e-463a-ada7-bfa8a89ba619', 'b72062a7-659f-4e0f-8a54-c68ec7357fae', 'Triển khai', 'Triển khai sản phẩm vào thực tế', 5, '2025-05-04 01:28:31.649906+00', NULL);


--
-- TOC entry 3562 (class 0 OID 16734)
-- Dependencies: 220
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.departments VALUES ('636902d1-7100-49fc-aec3-fd999a1ea3b5', 'Quản lý vận hành', '', '15 QT');
INSERT INTO public.departments VALUES ('544349c4-bf36-4931-92c7-5e50690a6556', 'Phòng Kế hoạch quản trị', '', '15 Quang Trung Đà Nẵng');
INSERT INTO public.departments VALUES ('e03b79f2-bacc-47c7-8b10-6305b6623d06', 'Phòng Phát triển Phần mềm 2', '', '15 Quang Trung ');
INSERT INTO public.departments VALUES ('a8c07416-e54f-4fd9-bdd5-b9cfa0191c0a', 'Phòng Phát triển Phần mềm 1', '', 'Khu Công nghệ cao Hòa Lạc, Tòa nhà Beta, Tầng 3');
INSERT INTO public.departments VALUES ('a46b34ca-c156-43c9-91b0-7e74ad46dd90', 'Phòng Công nghệ Tư vấn', 'Phòng Công nghệ Tư vấn', '');
INSERT INTO public.departments VALUES ('c3a8d585-9701-4cbe-9d51-696f574fa0af', 'Ban Giám đốc', '', '');


--
-- TOC entry 3563 (class 0 OID 16740)
-- Dependencies: 221
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.employees VALUES ('bb81a5ff-d843-4c89-aa6e-cd371731a4ad', 'Sơn', 'Ngô Thái', 'ngothaison@dnict.com.vn', '0912345678', '2024-03-10', 'Kỹ sư Phần mềm', '636902d1-7100-49fc-aec3-fd999a1ea3b5', 'cc3ea5ef-6594-4a69-b4d4-3a1f61b92c2d', 18000000.00, '2025-05-02 08:32:18.228498+00', '2025-05-02 08:32:18.228498+00', '5d6527f4-a4e3-4369-ad4e-686c79b59c83', 'ngothaison', true, NULL);
INSERT INTO public.employees VALUES ('ec063a6f-4ee1-4677-a6c6-0f9c2dd0b070', 'Nguyệt', 'Thu', 'thunguyet@dnict.com.vn', '0922345678', '2023-03-10', 'Trưởng phòng', '544349c4-bf36-4931-92c7-5e50690a6556', '16f1c827-eace-49ee-b22a-c049b7adaf7e', 18000000.00, '2025-05-02 13:23:33.12291+00', '2025-05-02 13:23:33.12291+00', '91d989c1-9d42-42ed-9d9d-0371058a98bf', 'thunguyet', true, NULL);
INSERT INTO public.employees VALUES ('16f1c827-eace-49ee-b22a-c049b7adaf7e', 'Giang', 'Lam', 'admin.user@example.com', '123-456-7890', '2024-01-15', 'Giám đốc', 'c3a8d585-9701-4cbe-9d51-696f574fa0af', NULL, 85000.00, '2025-05-01 02:05:14.842245+00', '2025-05-05 06:50:41.731322+00', '82b32ceb-93e6-4ed9-8e81-27ce20db5380', 'admin', true, NULL);
INSERT INTO public.employees VALUES ('875e512e-3f81-4b40-9ea0-e9c6a306c54c', 'Hằng', 'Minh', 'minhhang@dnict.com.vn', '0922345678', '2023-03-10', 'Trưởng phòng', '544349c4-bf36-4931-92c7-5e50690a6556', 'ec063a6f-4ee1-4677-a6c6-0f9c2dd0b070', 18000000.00, '2025-05-03 03:40:13.368668+00', '2025-05-05 06:51:55.483232+00', '91d989c1-9d42-42ed-9d9d-0371058a98bf', 'minhhang', true, NULL);
INSERT INTO public.employees VALUES ('37130ea0-ae3f-4821-af2e-917cf83e24b5', 'Vân', 'Thanh', 'thanhvan@dnict.com.vn', '0922345678', '2023-03-10', 'Nhân viên Hành chính', '544349c4-bf36-4931-92c7-5e50690a6556', 'ec063a6f-4ee1-4677-a6c6-0f9c2dd0b070', 18000000.00, '2025-05-02 13:07:53.966296+00', '2025-05-05 06:52:03.411979+00', 'e654a4a8-47d0-4970-9b5c-33a63498f154', 'thanhvan', true, NULL);
INSERT INTO public.employees VALUES ('cc3ea5ef-6594-4a69-b4d4-3a1f61b92c2d', 'Quang', 'Trần', 'tranquang@dnict.com.vn', '0987654321', '2024-07-26', 'Trưởng phòng', '636902d1-7100-49fc-aec3-fd999a1ea3b5', '16f1c827-eace-49ee-b22a-c049b7adaf7e', 60000.00, '2025-05-01 23:37:41.834773+00', '2025-05-05 10:03:32.672193+00', '91d989c1-9d42-42ed-9d9d-0371058a98bf', 'tranquang', true, NULL);


--
-- TOC entry 3564 (class 0 OID 16748)
-- Dependencies: 222
-- Data for Name: job_title_roles; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.job_title_roles VALUES ('82b32ceb-93e6-4ed9-8e81-27ce20db5380', 'ROLE_ADMIN');
INSERT INTO public.job_title_roles VALUES ('91d989c1-9d42-42ed-9d9d-0371058a98bf', 'ROLE_USER');
INSERT INTO public.job_title_roles VALUES ('5d6527f4-a4e3-4369-ad4e-686c79b59c83', 'ROLE_USER');
INSERT INTO public.job_title_roles VALUES ('e654a4a8-47d0-4970-9b5c-33a63498f154', 'ROLE_USER');
INSERT INTO public.job_title_roles VALUES ('82b32ceb-93e6-4ed9-8e81-27ce20db5380', 'ROLE_PROJECT_MANAGER');
INSERT INTO public.job_title_roles VALUES ('82b32ceb-93e6-4ed9-8e81-27ce20db5380', 'ROLE_USER');
INSERT INTO public.job_title_roles VALUES ('91d989c1-9d42-42ed-9d9d-0371058a98bf', 'ROLE_PROJECT_MANAGER');


--
-- TOC entry 3565 (class 0 OID 16751)
-- Dependencies: 223
-- Data for Name: jobtitles; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.jobtitles VALUES ('82b32ceb-93e6-4ed9-8e81-27ce20db5380', 'Giám đốc', 'Giám đốc', '2025-04-30 22:43:46.908999+00', '2025-04-30 22:43:46.908999+00');
INSERT INTO public.jobtitles VALUES ('91d989c1-9d42-42ed-9d9d-0371058a98bf', 'Trưởng phòng', 'Trưởng phòng', '2025-05-01 23:34:47.697014+00', '2025-05-01 23:34:47.697014+00');
INSERT INTO public.jobtitles VALUES ('5d6527f4-a4e3-4369-ad4e-686c79b59c83', 'Kỹ sư Phần mềm', 'Chịu trách nhiệm thiết kế, phát triển và bảo trì các ứng dụng phần mềm phức tạp.', '2025-05-02 08:17:07.071389+00', '2025-05-02 08:17:07.071389+00');
INSERT INTO public.jobtitles VALUES ('e654a4a8-47d0-4970-9b5c-33a63498f154', 'Nhân viên Hành chính', 'Quản lý hành chính', '2025-05-02 08:17:53.242322+00', '2025-05-02 08:17:53.242322+00');


--
-- TOC entry 3566 (class 0 OID 16758)
-- Dependencies: 224
-- Data for Name: meetings; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3567 (class 0 OID 16765)
-- Dependencies: 225
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3568 (class 0 OID 16773)
-- Dependencies: 226
-- Data for Name: projectmembers; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3569 (class 0 OID 16777)
-- Dependencies: 227
-- Data for Name: projectmilestones; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3570 (class 0 OID 16785)
-- Dependencies: 228
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.projects VALUES ('0451d67f-6397-49ab-8f2b-f0cd25e21ab6', 'Triển khai Hệ thống CRM Nội bộ', 'Dự án nhằm nâng cấp và thay thế hệ thống quản lý khách hàng hiện tại bằng một giải pháp CRM mới, tích hợp các quy trình bán hàng và chăm sóc khách hàng.', '2025-08-01', '2026-02-28', 'NOT_STARTED', 'HIGH', 'cc3ea5ef-6594-4a69-b4d4-3a1f61b92c2d', '2025-05-02 07:59:37.16582+00', '2025-05-02 07:59:37.16582+00', NULL);
INSERT INTO public.projects VALUES ('db319396-d4cb-49b9-8290-d174b23f7928', 'Nâng cấp Server Database', 'Nâng cấp phiên bản hệ quản trị cơ sở dữ liệu chính lên phiên bản mới nhất để cải thiện hiệu năng và bảo mật.', '2025-06-10', '2025-07-15', 'PLANNING', 'HIGH', 'bb81a5ff-d843-4c89-aa6e-cd371731a4ad', '2025-05-02 10:04:22.402397+00', '2025-05-02 10:04:22.402397+00', NULL);
INSERT INTO public.projects VALUES ('5843f76b-92f9-4948-b701-bdaa4636b698', 'Chiến dịch Ra mắt Sản phẩm Mới Q3', 'Lên kế hoạch và thực hiện chiến dịch marketing đa kênh cho việc ra mắt sản phẩm XYZ vào quý 3.', '2025-07-01', '2025-09-30', 'NOT_STARTED', 'MEDIUM', 'bb81a5ff-d843-4c89-aa6e-cd371731a4ad', '2025-05-02 10:04:55.469735+00', '2025-05-02 10:04:55.469735+00', NULL);


--
-- TOC entry 3571 (class 0 OID 16793)
-- Dependencies: 229
-- Data for Name: projectstages; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.projectstages VALUES ('889f4c66-f455-4eaa-90d6-4a9cbf93514b', '5843f76b-92f9-4948-b701-bdaa4636b698', 'Giai đoạn 1: Khảo sát', NULL, NULL, NULL, NULL, 1, '2025-05-02 10:35:46.411586+00', '2025-05-02 10:35:46.412585+00');
INSERT INTO public.projectstages VALUES ('1a488980-a92a-44fa-92d0-eaa64cfbcf8e', '5843f76b-92f9-4948-b701-bdaa4636b698', 'Giai đoạn 2: Phân tích', 'Phân tích yêu cầu và dữ liệu khảo sát.', '2025-08-01', NULL, NULL, 2, '2025-05-02 10:35:46.443829+00', '2025-05-02 10:35:46.444343+00');
INSERT INTO public.projectstages VALUES ('3668793c-9fe0-4355-a889-d11bae89dde3', '5843f76b-92f9-4948-b701-bdaa4636b698', 'Giai đoạn 3: Thiết kế', NULL, NULL, NULL, 'To Do', NULL, '2025-05-02 10:35:46.450423+00', '2025-05-02 10:35:46.450423+00');
INSERT INTO public.projectstages VALUES ('88893639-4a73-4a92-9ed6-0031147dfad7', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', 'Giai đoạn 1: Phân tích yêu cầu CRM', 'Thu thập và phân tích chi tiết các yêu cầu cho hệ thống CRM mới.', '2025-08-05', '2025-08-30', 'PLANNING', 1, '2025-05-12 01:47:24.660512+00', '2025-05-12 01:47:24.660512+00');
INSERT INTO public.projectstages VALUES ('74ef03fc-2af0-4c60-b1dc-79d40675f843', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', 'Giai đoạn 2: Thiết kế giải pháp CRM', 'Thiết kế kiến trúc và giao diện người dùng cho hệ thống CRM.', '2025-09-01', '2025-09-30', 'NOT_STARTED', 2, '2025-05-12 01:47:24.668114+00', '2025-05-12 01:47:24.668114+00');
INSERT INTO public.projectstages VALUES ('0a11e061-cb4c-4808-a03f-dfacc2760f8a', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', 'Giai đoạn 3: Phát triển CRM', 'Xây dựng các module và tính năng của hệ thống CRM.', '2025-10-01', '2025-12-31', 'NOT_STARTED', 3, '2025-05-12 01:47:24.669655+00', '2025-05-12 01:47:24.669655+00');
INSERT INTO public.projectstages VALUES ('1a5350d2-39e3-42ce-af9c-8c41ed860248', 'db319396-d4cb-49b9-8290-d174b23f7928', 'Giai đoạn 1: Chuẩn bị và Sao lưu', 'Chuẩn bị môi trường, kiểm tra tương thích và thực hiện sao lưu toàn bộ cơ sở dữ liệu hiện tại.', '2025-06-12', '2025-06-20', 'PLANNING', 1, '2025-05-12 01:48:29.068639+00', '2025-05-12 01:48:29.068639+00');
INSERT INTO public.projectstages VALUES ('247ed0c8-200f-4797-b7ee-73e00a4099c4', 'db319396-d4cb-49b9-8290-d174b23f7928', 'Giai đoạn 2: Thực hiện Nâng cấp', 'Tiến hành nâng cấp hệ quản trị cơ sở dữ liệu trên môi trường staging, sau đó là production.', '2025-06-21', '2025-07-05', 'NOT_STARTED', 2, '2025-05-12 01:48:29.070253+00', '2025-05-12 01:48:29.070253+00');
INSERT INTO public.projectstages VALUES ('fb1e777d-e9b0-4876-9cf8-17c097328341', 'db319396-d4cb-49b9-8290-d174b23f7928', 'Giai đoạn 3: Kiểm thử và Tối ưu', 'Kiểm tra hoạt động của hệ thống sau nâng cấp, theo dõi hiệu năng và tối ưu nếu cần.', '2025-07-06', '2025-07-14', 'NOT_STARTED', 3, '2025-05-12 01:48:29.071811+00', '2025-05-12 01:48:29.071811+00');


--
-- TOC entry 3572 (class 0 OID 16801)
-- Dependencies: 230
-- Data for Name: projecttypes; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.projecttypes VALUES ('0fdf11a8-bdae-4d62-a374-e0fd3a107826', 'Phát triển phần mềm', 'Dự án liên quan đến việc phát triển các ứng dụng hoặc hệ thống phần mềm.', '2025-05-04 01:26:08.58745+00', NULL);
INSERT INTO public.projecttypes VALUES ('582d6c44-e0e6-46c3-8e95-a3a017971072', 'Xây dựng', 'Dự án liên quan đến xây dựng các công trình dân dụng hoặc công nghiệp.', '2025-05-04 01:26:08.58745+00', NULL);
INSERT INTO public.projecttypes VALUES ('4781e43c-50da-4022-a168-2b43ca74b936', 'Marketing', 'Dự án liên quan đến các hoạt động marketing và quảng bá sản phẩm/dịch vụ.', '2025-05-04 01:26:08.58745+00', NULL);
INSERT INTO public.projecttypes VALUES ('b72062a7-659f-4e0f-8a54-c68ec7357fae', 'Nghiên cứu và Phát triển', 'Dự án tập trung vào nghiên cứu và phát triển sản phẩm hoặc công nghệ mới.', '2025-05-04 01:26:08.58745+00', NULL);
INSERT INTO public.projecttypes VALUES ('6fdc95dc-4ebf-4114-8cf3-39c451110d8b', 'Tổ chức sự kiện', 'Dự án liên quan đến việc lên kế hoạch và tổ chức các sự kiện.', '2025-05-04 01:26:08.58745+00', NULL);


--
-- TOC entry 3578 (class 0 OID 17036)
-- Dependencies: 236
-- Data for Name: projectworks; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.projectworks VALUES ('7b4952f1-6bdc-41ea-9ceb-be1a7b996390', 'Xác định các bên liên quan chính', 'Lập danh sách và phỏng vấn các bên liên quan để hiểu rõ nhu cầu về CRM.', '2025-08-06', '2025-08-10', 'TODO', 'HIGH', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', '2025-05-12 02:24:04.370293+00', '2025-05-12 02:24:04.370293+00');
INSERT INTO public.projectworks VALUES ('081bb495-7387-417d-be7c-8b686f10d075', 'Tài liệu hóa yêu cầu người dùng (User Stories)', 'Viết tài liệu chi tiết về các user story và use case cho hệ thống CRM.', '2025-08-11', '2025-08-20', 'TODO', 'HIGH', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', '2025-05-12 02:24:04.377664+00', '2025-05-12 02:24:04.377664+00');
INSERT INTO public.projectworks VALUES ('bb018d13-55f6-4bf6-9a87-c2a5601e5ae1', 'Phân tích yêu cầu kỹ thuật và tích hợp', 'Đánh giá các yêu cầu về mặt kỹ thuật, khả năng tích hợp với các hệ thống hiện có.', '2025-08-21', '2025-08-28', 'TODO', 'MEDIUM', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', '2025-05-12 02:24:04.378693+00', '2025-05-12 02:24:04.378693+00');
INSERT INTO public.projectworks VALUES ('db3145c2-9723-4068-ba09-9438b9bbba5f', 'Nâng cấp DB trên môi trường Staging', 'Thực hiện quy trình nâng cấp cơ sở dữ liệu trên server staging, ghi nhận các vấn đề phát sinh nếu có.', '2025-06-22', '2025-06-25', 'TODO', 'HIGH', 'db319396-d4cb-49b9-8290-d174b23f7928', '247ed0c8-200f-4797-b7ee-73e00a4099c4', '2025-05-12 02:24:49.582272+00', '2025-05-12 02:24:49.582272+00');
INSERT INTO public.projectworks VALUES ('f75a3fcb-fbf4-40e7-b933-fb61097d1f36', 'Kiểm thử toàn diện sau nâng cấp Staging', 'Kiểm tra tất cả các chức năng ứng dụng quan trọng trên môi trường staging sau khi nâng cấp DB.', '2025-06-26', '2025-06-28', 'TODO', 'HIGH', 'db319396-d4cb-49b9-8290-d174b23f7928', '247ed0c8-200f-4797-b7ee-73e00a4099c4', '2025-05-12 02:24:49.586711+00', '2025-05-12 02:24:49.586711+00');
INSERT INTO public.projectworks VALUES ('ddb85234-c85e-41da-8afd-901f2bd3cbc6', 'Lên kế hoạch chi tiết cho nâng cấp Production', 'Dựa trên kết quả từ staging, hoàn thiện kế hoạch và checklist cho việc nâng cấp production.', '2025-06-29', '2025-06-30', 'TODO', 'MEDIUM', 'db319396-d4cb-49b9-8290-d174b23f7928', '247ed0c8-200f-4797-b7ee-73e00a4099c4', '2025-05-12 02:24:49.588252+00', '2025-05-12 02:24:49.588252+00');
INSERT INTO public.projectworks VALUES ('047f89a8-1241-4812-bd14-b415ea07a677', 'Nâng cấp DB trên môi trường Production', 'Áp dụng quy trình nâng cấp đã được kiểm thử lên server production trong thời gian downtime đã được duyệt.', '2025-07-01', '2025-07-02', 'TODO', 'CRITICAL', 'db319396-d4cb-49b9-8290-d174b23f7928', '247ed0c8-200f-4797-b7ee-73e00a4099c4', '2025-05-12 02:24:49.589809+00', '2025-05-12 02:24:49.589809+00');
INSERT INTO public.projectworks VALUES ('e92b1e5d-309a-4061-b451-7c832c2897bd', 'Nghiên cứu giải pháp CRM tổng thể', 'Đánh giá các nhà cung cấp CRM trên thị trường và các tính năng phù hợp với yêu cầu chung của dự án.', '2025-07-15', '2025-07-30', 'PLANNING', 'HIGH', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', NULL, '2025-05-12 02:28:44.561346+00', '2025-05-12 02:28:44.561346+00');
INSERT INTO public.projectworks VALUES ('0f52b685-bb26-4f7a-8fbf-f390322b4143', 'Lên kế hoạch đào tạo người dùng cuối', 'Xây dựng khung chương trình và tài liệu đào tạo cho nhân viên sử dụng hệ thống CRM mới.', '2026-01-10', '2026-01-30', 'TODO', 'MEDIUM', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', NULL, '2025-05-12 02:28:44.565958+00', '2025-05-12 02:28:44.565958+00');
INSERT INTO public.projectworks VALUES ('2efe8b14-9a15-4a19-902d-7346e6fd8f91', 'Thiết lập chính sách bảo mật dữ liệu CRM', 'Xác định các quy tắc và chính sách liên quan đến việc truy cập và bảo mật dữ liệu khách hàng trên hệ thống CRM.', NULL, NULL, 'TODO', 'HIGH', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', NULL, '2025-05-12 02:28:44.571608+00', '2025-05-12 02:28:44.572127+00');


--
-- TOC entry 3573 (class 0 OID 16808)
-- Dependencies: 231
-- Data for Name: taskcomments; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3574 (class 0 OID 16815)
-- Dependencies: 232
-- Data for Name: taskdependencies; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3575 (class 0 OID 16821)
-- Dependencies: 233
-- Data for Name: taskprogresschecklistitems; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3576 (class 0 OID 16824)
-- Dependencies: 234
-- Data for Name: taskprogressupdates; Type: TABLE DATA; Schema: public; Owner: myuser
--



--
-- TOC entry 3577 (class 0 OID 16832)
-- Dependencies: 235
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: myuser
--

INSERT INTO public.tasks VALUES ('ad2b1558-30c2-448c-a98e-ad5963407ba7', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', 'Lên danh sách các phòng ban liên quan', 'Xác định tất cả các phòng ban sẽ sử dụng hoặc bị ảnh hưởng bởi hệ thống CRM mới.', '2025-08-07', '2025-08-08', 'TODO', 'HIGH', NULL, '2025-05-12 03:54:17.392478+00', '2025-05-12 03:54:17.392478+00', '7b4952f1-6bdc-41ea-9ceb-be1a7b996390');
INSERT INTO public.tasks VALUES ('4f4da7dd-7362-41dd-a6c3-798b4258e78b', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', 'Chuẩn bị câu hỏi phỏng vấn cho các trưởng phòng', 'Soạn thảo bộ câu hỏi chi tiết để thu thập thông tin từ các trưởng phòng ban liên quan.', '2025-08-08', '2025-08-09', 'TODO', 'MEDIUM', 'cc3ea5ef-6594-4a69-b4d4-3a1f61b92c2d', '2025-05-12 03:54:17.413022+00', '2025-05-12 03:54:17.413022+00', '7b4952f1-6bdc-41ea-9ceb-be1a7b996390');
INSERT INTO public.tasks VALUES ('7cc3f84c-c175-44a1-8d77-f90f63293121', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', 'Đặt lịch phỏng vấn với các bên liên quan', 'Liên hệ và sắp xếp thời gian phỏng vấn phù hợp với các cá nhân/phòng ban đã xác định.', '2025-08-09', '2025-08-10', 'TODO', 'MEDIUM', NULL, '2025-05-12 03:54:17.414558+00', '2025-05-12 03:54:17.414558+00', '7b4952f1-6bdc-41ea-9ceb-be1a7b996390');
INSERT INTO public.tasks VALUES ('342fb716-79a2-4cde-a163-a380a7c71e0d', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', 'Đánh giá khả năng tích hợp với hệ thống Kế toán', 'Xem xét các API và phương thức tích hợp dữ liệu giữa CRM mới và hệ thống kế toán hiện tại.', '2025-08-22', '2025-08-24', 'TODO', 'HIGH', NULL, '2025-05-12 03:55:46.283446+00', '2025-05-12 03:55:46.283446+00', 'bb018d13-55f6-4bf6-9a87-c2a5601e5ae1');
INSERT INTO public.tasks VALUES ('b0d6ddbb-9659-4cd3-9d55-db5242da2b1a', '0451d67f-6397-49ab-8f2b-f0cd25e21ab6', '88893639-4a73-4a92-9ed6-0031147dfad7', 'Xác định yêu cầu về hạ tầng cho CRM', 'Phân tích yêu cầu về server, database, băng thông và các yếu tố hạ tầng khác để triển khai CRM.', '2025-08-25', '2025-08-27', 'TODO', 'MEDIUM', 'cc3ea5ef-6594-4a69-b4d4-3a1f61b92c2d', '2025-05-12 03:55:46.285018+00', '2025-05-12 03:55:46.285018+00', 'bb018d13-55f6-4bf6-9a87-c2a5601e5ae1');


--
-- TOC entry 3311 (class 2606 OID 16841)
-- Name: app_user app_user_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 3313 (class 2606 OID 16843)
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (app_user_id);


--
-- TOC entry 3317 (class 2606 OID 16845)
-- Name: attachments attachments_entity_type_entity_id_file_name_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_entity_type_entity_id_file_name_key UNIQUE (entity_type, entity_id, file_name);


--
-- TOC entry 3319 (class 2606 OID 16847)
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (attachment_id);


--
-- TOC entry 3321 (class 2606 OID 16849)
-- Name: available_roles available_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.available_roles
    ADD CONSTRAINT available_roles_pkey PRIMARY KEY (role_name);


--
-- TOC entry 3323 (class 2606 OID 16851)
-- Name: checklistitems checklistitems_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.checklistitems
    ADD CONSTRAINT checklistitems_pkey PRIMARY KEY (checklist_item_id);


--
-- TOC entry 3325 (class 2606 OID 16853)
-- Name: default_stages default_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.default_stages
    ADD CONSTRAINT default_stages_pkey PRIMARY KEY (default_stage_id);


--
-- TOC entry 3327 (class 2606 OID 16855)
-- Name: default_stages default_stages_project_type_id_order_number_unique; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.default_stages
    ADD CONSTRAINT default_stages_project_type_id_order_number_unique UNIQUE (project_type_id, order_number);


--
-- TOC entry 3329 (class 2606 OID 16857)
-- Name: default_stages default_stages_project_type_id_stage_name_unique; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.default_stages
    ADD CONSTRAINT default_stages_project_type_id_stage_name_unique UNIQUE (project_type_id, stage_name);


--
-- TOC entry 3331 (class 2606 OID 16859)
-- Name: departments departments_department_name_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);


--
-- TOC entry 3333 (class 2606 OID 16861)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- TOC entry 3337 (class 2606 OID 16863)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3344 (class 2606 OID 16865)
-- Name: jobtitles jobtitles_job_title_name_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.jobtitles
    ADD CONSTRAINT jobtitles_job_title_name_key UNIQUE (job_title_name);


--
-- TOC entry 3350 (class 2606 OID 16867)
-- Name: meetings meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_pkey PRIMARY KEY (meeting_id);


--
-- TOC entry 3352 (class 2606 OID 16869)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- TOC entry 3342 (class 2606 OID 16871)
-- Name: job_title_roles pk_job_title_roles; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.job_title_roles
    ADD CONSTRAINT pk_job_title_roles PRIMARY KEY (job_title_id, role);


--
-- TOC entry 3354 (class 2606 OID 16873)
-- Name: projectmembers projectmembers_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectmembers
    ADD CONSTRAINT projectmembers_pkey PRIMARY KEY (project_id, employee_id);


--
-- TOC entry 3356 (class 2606 OID 16875)
-- Name: projectmilestones projectmilestones_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectmilestones
    ADD CONSTRAINT projectmilestones_pkey PRIMARY KEY (milestone_id);


--
-- TOC entry 3358 (class 2606 OID 16877)
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);


--
-- TOC entry 3360 (class 2606 OID 16879)
-- Name: projectstages projectstages_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectstages
    ADD CONSTRAINT projectstages_pkey PRIMARY KEY (stage_id);


--
-- TOC entry 3362 (class 2606 OID 16881)
-- Name: projectstages projectstages_project_id_order_number_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectstages
    ADD CONSTRAINT projectstages_project_id_order_number_key UNIQUE (project_id, order_number);


--
-- TOC entry 3364 (class 2606 OID 16883)
-- Name: projectstages projectstages_project_id_stage_name_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectstages
    ADD CONSTRAINT projectstages_project_id_stage_name_key UNIQUE (project_id, stage_name);


--
-- TOC entry 3370 (class 2606 OID 16885)
-- Name: projecttypes projecttypes_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projecttypes
    ADD CONSTRAINT projecttypes_pkey PRIMARY KEY (project_type_id);


--
-- TOC entry 3372 (class 2606 OID 16887)
-- Name: projecttypes projecttypes_project_type_name_unique; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projecttypes
    ADD CONSTRAINT projecttypes_project_type_name_unique UNIQUE (project_type_name);


--
-- TOC entry 3386 (class 2606 OID 17045)
-- Name: projectworks projectworks_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectworks
    ADD CONSTRAINT projectworks_pkey PRIMARY KEY (work_id);


--
-- TOC entry 3346 (class 2606 OID 16889)
-- Name: jobtitles responsibilities_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.jobtitles
    ADD CONSTRAINT responsibilities_pkey PRIMARY KEY (job_title_id);


--
-- TOC entry 3348 (class 2606 OID 16891)
-- Name: jobtitles responsibilities_responsibility_name_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.jobtitles
    ADD CONSTRAINT responsibilities_responsibility_name_key UNIQUE (job_title_name);


--
-- TOC entry 3374 (class 2606 OID 16893)
-- Name: taskcomments taskcomments_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskcomments
    ADD CONSTRAINT taskcomments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3376 (class 2606 OID 16895)
-- Name: taskdependencies taskdependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskdependencies
    ADD CONSTRAINT taskdependencies_pkey PRIMARY KEY (dependency_id);


--
-- TOC entry 3378 (class 2606 OID 16897)
-- Name: taskdependencies taskdependencies_task_id_depends_on_task_id_key; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskdependencies
    ADD CONSTRAINT taskdependencies_task_id_depends_on_task_id_key UNIQUE (task_id, depends_on_task_id);


--
-- TOC entry 3380 (class 2606 OID 16899)
-- Name: taskprogresschecklistitems taskprogresschecklistitems_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskprogresschecklistitems
    ADD CONSTRAINT taskprogresschecklistitems_pkey PRIMARY KEY (progress_update_id, checklist_item_id);


--
-- TOC entry 3382 (class 2606 OID 16901)
-- Name: taskprogressupdates taskprogressupdates_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskprogressupdates
    ADD CONSTRAINT taskprogressupdates_pkey PRIMARY KEY (progress_update_id);


--
-- TOC entry 3384 (class 2606 OID 16903)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (task_id);


--
-- TOC entry 3315 (class 2606 OID 16905)
-- Name: app_user uk3k4cplvh82srueuttfkwnylq0; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT uk3k4cplvh82srueuttfkwnylq0 UNIQUE (username);


--
-- TOC entry 3366 (class 2606 OID 16907)
-- Name: projectstages ukdn3lti2ln5fetswk97bxu5vfi; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectstages
    ADD CONSTRAINT ukdn3lti2ln5fetswk97bxu5vfi UNIQUE (project_id, order_number);


--
-- TOC entry 3335 (class 2606 OID 16909)
-- Name: departments ukqyf2ekbfpnddm6f3rkgt39i9o; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT ukqyf2ekbfpnddm6f3rkgt39i9o UNIQUE (department_name);


--
-- TOC entry 3368 (class 2606 OID 16911)
-- Name: projectstages ukt7ljpebt78h5or6hxv4a8qk1q; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectstages
    ADD CONSTRAINT ukt7ljpebt78h5or6hxv4a8qk1q UNIQUE (project_id, stage_name);


--
-- TOC entry 3340 (class 1259 OID 16912)
-- Name: idx_job_title_roles_job_title_id; Type: INDEX; Schema: public; Owner: myuser
--

CREATE INDEX idx_job_title_roles_job_title_id ON public.job_title_roles USING btree (job_title_id);


--
-- TOC entry 3338 (class 1259 OID 16913)
-- Name: unique_active_email; Type: INDEX; Schema: public; Owner: myuser
--

CREATE UNIQUE INDEX unique_active_email ON public.employees USING btree (email) WHERE (active = true);


--
-- TOC entry 3339 (class 1259 OID 16914)
-- Name: unique_active_username; Type: INDEX; Schema: public; Owner: myuser
--

CREATE UNIQUE INDEX unique_active_username ON public.employees USING btree (username) WHERE (active = true);


--
-- TOC entry 3388 (class 2606 OID 16915)
-- Name: checklistitems checklistitems_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.checklistitems
    ADD CONSTRAINT checklistitems_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE CASCADE;


--
-- TOC entry 3389 (class 2606 OID 16920)
-- Name: default_stages default_stages_project_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.default_stages
    ADD CONSTRAINT default_stages_project_type_id_fkey FOREIGN KEY (project_type_id) REFERENCES public.projecttypes(project_type_id) ON DELETE CASCADE;


--
-- TOC entry 3390 (class 2606 OID 16925)
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- TOC entry 3391 (class 2606 OID 16930)
-- Name: employees employees_job_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_job_title_id_fkey FOREIGN KEY (job_title_id) REFERENCES public.jobtitles(job_title_id);


--
-- TOC entry 3392 (class 2606 OID 16935)
-- Name: employees employees_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3387 (class 2606 OID 16940)
-- Name: app_user fk_app_user_employee; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT fk_app_user_employee FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3393 (class 2606 OID 16945)
-- Name: employees fk_employees_app_user; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_employees_app_user FOREIGN KEY (app_user_id) REFERENCES public.app_user(app_user_id);


--
-- TOC entry 3394 (class 2606 OID 16950)
-- Name: job_title_roles fk_job_title_roles_jobtitle; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.job_title_roles
    ADD CONSTRAINT fk_job_title_roles_jobtitle FOREIGN KEY (job_title_id) REFERENCES public.jobtitles(job_title_id) ON DELETE CASCADE;


--
-- TOC entry 3395 (class 2606 OID 16955)
-- Name: meetings meetings_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- TOC entry 3396 (class 2606 OID 16960)
-- Name: projectmembers projectmembers_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectmembers
    ADD CONSTRAINT projectmembers_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id) ON DELETE CASCADE;


--
-- TOC entry 3397 (class 2606 OID 16965)
-- Name: projectmembers projectmembers_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectmembers
    ADD CONSTRAINT projectmembers_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- TOC entry 3398 (class 2606 OID 16970)
-- Name: projectmilestones projectmilestones_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectmilestones
    ADD CONSTRAINT projectmilestones_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- TOC entry 3399 (class 2606 OID 16975)
-- Name: projects projects_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3400 (class 2606 OID 16980)
-- Name: projects projects_project_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_project_type_id_fkey FOREIGN KEY (project_type_id) REFERENCES public.projecttypes(project_type_id);


--
-- TOC entry 3401 (class 2606 OID 16985)
-- Name: projectstages projectstages_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectstages
    ADD CONSTRAINT projectstages_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- TOC entry 3412 (class 2606 OID 17046)
-- Name: projectworks projectworks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectworks
    ADD CONSTRAINT projectworks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- TOC entry 3413 (class 2606 OID 17051)
-- Name: projectworks projectworks_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.projectworks
    ADD CONSTRAINT projectworks_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.projectstages(stage_id) ON DELETE CASCADE;


--
-- TOC entry 3402 (class 2606 OID 16990)
-- Name: taskcomments taskcomments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskcomments
    ADD CONSTRAINT taskcomments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE CASCADE;


--
-- TOC entry 3403 (class 2606 OID 16995)
-- Name: taskdependencies taskdependencies_depends_on_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskdependencies
    ADD CONSTRAINT taskdependencies_depends_on_task_id_fkey FOREIGN KEY (depends_on_task_id) REFERENCES public.tasks(task_id) ON DELETE CASCADE;


--
-- TOC entry 3404 (class 2606 OID 17000)
-- Name: taskdependencies taskdependencies_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskdependencies
    ADD CONSTRAINT taskdependencies_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE CASCADE;


--
-- TOC entry 3405 (class 2606 OID 17005)
-- Name: taskprogresschecklistitems taskprogresschecklistitems_checklist_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskprogresschecklistitems
    ADD CONSTRAINT taskprogresschecklistitems_checklist_item_id_fkey FOREIGN KEY (checklist_item_id) REFERENCES public.checklistitems(checklist_item_id) ON DELETE CASCADE;


--
-- TOC entry 3406 (class 2606 OID 17010)
-- Name: taskprogresschecklistitems taskprogresschecklistitems_progress_update_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskprogresschecklistitems
    ADD CONSTRAINT taskprogresschecklistitems_progress_update_id_fkey FOREIGN KEY (progress_update_id) REFERENCES public.taskprogressupdates(progress_update_id) ON DELETE CASCADE;


--
-- TOC entry 3407 (class 2606 OID 17015)
-- Name: taskprogressupdates taskprogressupdates_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.taskprogressupdates
    ADD CONSTRAINT taskprogressupdates_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(task_id) ON DELETE CASCADE;


--
-- TOC entry 3408 (class 2606 OID 17020)
-- Name: tasks tasks_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.employees(employee_id);


--
-- TOC entry 3409 (class 2606 OID 17025)
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(project_id) ON DELETE CASCADE;


--
-- TOC entry 3410 (class 2606 OID 17030)
-- Name: tasks tasks_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.projectstages(stage_id) ON DELETE SET NULL;


--
-- TOC entry 3411 (class 2606 OID 17056)
-- Name: tasks tasks_work_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_work_id_fkey FOREIGN KEY (work_id) REFERENCES public.projectworks(work_id) ON DELETE CASCADE;


-- Completed on 2025-05-12 04:23:57 UTC

--
-- PostgreSQL database dump complete
--

