--
-- PostgreSQL database dump
--

\restrict kAEEoaTFyJzrnuKs2LVEUucR9lOrpImTjcPPqDwKMaH8B3myMFhWphfxNial0T8

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

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
-- Name: afericoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.afericoes (
    id bigint NOT NULL,
    bico_id bigint NOT NULL,
    funcionario_id bigint NOT NULL,
    realizada_em timestamp(6) without time zone NOT NULL,
    volume_indicado_litros numeric(10,3) NOT NULL,
    volume_aferido_litros numeric(10,3) NOT NULL,
    diferenca_litros numeric(10,3) NOT NULL,
    observacoes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_afericoes_volume_aferido CHECK ((volume_aferido_litros >= (0)::numeric)),
    CONSTRAINT chk_afericoes_volume_indicado CHECK ((volume_indicado_litros >= (0)::numeric))
);


--
-- Name: afericoes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.afericoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: afericoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.afericoes_id_seq OWNED BY public.afericoes.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: auditoria_eventos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auditoria_eventos (
    id bigint NOT NULL,
    funcionario_id bigint,
    entidade character varying NOT NULL,
    entidade_id bigint,
    acao character varying NOT NULL,
    dados jsonb DEFAULT '{}'::jsonb NOT NULL,
    ocorrido_em timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_auditoria_eventos_acao CHECK (((acao)::text = ANY ((ARRAY['criado'::character varying, 'atualizado'::character varying, 'removido'::character varying, 'login'::character varying, 'logout'::character varying, 'erro'::character varying])::text[])))
);


--
-- Name: auditoria_eventos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auditoria_eventos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auditoria_eventos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auditoria_eventos_id_seq OWNED BY public.auditoria_eventos.id;


--
-- Name: bicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bicos (
    id bigint NOT NULL,
    bomba_id bigint NOT NULL,
    tanque_id bigint NOT NULL,
    numero integer NOT NULL,
    codigo character varying NOT NULL,
    encerrante_litros numeric(14,3) DEFAULT 0.0 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_bicos_encerrante_non_negative CHECK ((encerrante_litros >= (0)::numeric)),
    CONSTRAINT chk_bicos_numero_positive CHECK ((numero > 0))
);


--
-- Name: bicos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bicos_id_seq OWNED BY public.bicos.id;


--
-- Name: bombas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bombas (
    id bigint NOT NULL,
    codigo character varying NOT NULL,
    descricao text,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bombas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bombas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bombas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bombas_id_seq OWNED BY public.bombas.id;


--
-- Name: caixas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.caixas (
    id bigint NOT NULL,
    escala_id bigint NOT NULL,
    funcionario_id bigint NOT NULL,
    aberto_em timestamp(6) without time zone NOT NULL,
    fechado_em timestamp(6) without time zone,
    valor_inicial numeric(12,2) DEFAULT 0.0 NOT NULL,
    valor_final numeric(12,2),
    status character varying DEFAULT 'aberto'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_caixas_periodo CHECK (((fechado_em IS NULL) OR (fechado_em >= aberto_em))),
    CONSTRAINT chk_caixas_status CHECK (((status)::text = ANY ((ARRAY['aberto'::character varying, 'fechado'::character varying, 'cancelado'::character varying])::text[]))),
    CONSTRAINT chk_caixas_valor_final CHECK (((valor_final IS NULL) OR (valor_final >= (0)::numeric))),
    CONSTRAINT chk_caixas_valor_inicial CHECK ((valor_inicial >= (0)::numeric))
);


--
-- Name: caixas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.caixas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caixas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.caixas_id_seq OWNED BY public.caixas.id;


--
-- Name: calibracoes_bicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calibracoes_bicos (
    id bigint NOT NULL,
    bico_id bigint NOT NULL,
    funcionario_id bigint NOT NULL,
    realizada_em timestamp(6) without time zone NOT NULL,
    vazao_litros_minuto numeric(10,3) NOT NULL,
    desvio_percentual numeric(8,4) DEFAULT 0.0 NOT NULL,
    status character varying DEFAULT 'aprovada'::character varying NOT NULL,
    observacoes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_calibracoes_bicos_status CHECK (((status)::text = ANY ((ARRAY['aprovada'::character varying, 'reprovada'::character varying])::text[]))),
    CONSTRAINT chk_calibracoes_bicos_vazao CHECK ((vazao_litros_minuto > (0)::numeric))
);


--
-- Name: calibracoes_bicos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calibracoes_bicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calibracoes_bicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calibracoes_bicos_id_seq OWNED BY public.calibracoes_bicos.id;


--
-- Name: cargo_permissoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cargo_permissoes (
    id bigint NOT NULL,
    cargo_id bigint NOT NULL,
    permissao_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cargo_permissoes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cargo_permissoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cargo_permissoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cargo_permissoes_id_seq OWNED BY public.cargo_permissoes.id;


--
-- Name: cargos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cargos (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    descricao text,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cargos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cargos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cargos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cargos_id_seq OWNED BY public.cargos.id;


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorias (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    descricao text,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: cliente_pessoas_fisicas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cliente_pessoas_fisicas (
    id bigint NOT NULL,
    cliente_id bigint NOT NULL,
    nome character varying NOT NULL,
    cpf character varying(11) NOT NULL,
    data_nascimento date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_cliente_pessoas_fisicas_cpf_length CHECK ((char_length((cpf)::text) = 11))
);


--
-- Name: cliente_pessoas_fisicas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cliente_pessoas_fisicas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cliente_pessoas_fisicas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cliente_pessoas_fisicas_id_seq OWNED BY public.cliente_pessoas_fisicas.id;


--
-- Name: cliente_pessoas_juridicas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cliente_pessoas_juridicas (
    id bigint NOT NULL,
    cliente_id bigint NOT NULL,
    razao_social character varying NOT NULL,
    nome_fantasia character varying,
    cnpj character varying(14) NOT NULL,
    inscricao_estadual character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_cliente_pessoas_juridicas_cnpj_length CHECK ((char_length((cnpj)::text) = 14))
);


--
-- Name: cliente_pessoas_juridicas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cliente_pessoas_juridicas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cliente_pessoas_juridicas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cliente_pessoas_juridicas_id_seq OWNED BY public.cliente_pessoas_juridicas.id;


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clientes (
    id bigint NOT NULL,
    endereco_id bigint,
    tipo character varying NOT NULL,
    email character varying,
    telefone character varying,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_clientes_tipo CHECK (((tipo)::text = ANY ((ARRAY['pf'::character varying, 'pj'::character varying])::text[])))
);


--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clientes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: combustiveis; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.combustiveis (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    tipo character varying NOT NULL,
    codigo_anp character varying NOT NULL,
    unidade_medida character varying DEFAULT 'litro'::character varying NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: combustiveis_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.combustiveis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: combustiveis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.combustiveis_id_seq OWNED BY public.combustiveis.id;


--
-- Name: contas_receber; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contas_receber (
    id bigint NOT NULL,
    cliente_id bigint NOT NULL,
    venda_id bigint NOT NULL,
    numero character varying NOT NULL,
    valor_total numeric(14,2) NOT NULL,
    saldo numeric(14,2) NOT NULL,
    vencimento_em date NOT NULL,
    status character varying DEFAULT 'aberta'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_contas_receber_saldo CHECK ((saldo >= (0)::numeric)),
    CONSTRAINT chk_contas_receber_saldo_total CHECK ((saldo <= valor_total)),
    CONSTRAINT chk_contas_receber_status CHECK (((status)::text = ANY ((ARRAY['aberta'::character varying, 'paga'::character varying, 'vencida'::character varying, 'cancelada'::character varying])::text[]))),
    CONSTRAINT chk_contas_receber_valor_total CHECK ((valor_total >= (0)::numeric))
);


--
-- Name: contas_receber_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contas_receber_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contas_receber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contas_receber_id_seq OWNED BY public.contas_receber.id;


--
-- Name: cupons_fiscais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cupons_fiscais (
    id bigint NOT NULL,
    venda_id bigint NOT NULL,
    numero character varying NOT NULL,
    serie character varying NOT NULL,
    chave_acesso character varying(44) NOT NULL,
    emitido_em timestamp(6) without time zone NOT NULL,
    valor_total numeric(14,2) NOT NULL,
    status character varying DEFAULT 'emitido'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_cupons_fiscais_chave_length CHECK ((char_length((chave_acesso)::text) = 44)),
    CONSTRAINT chk_cupons_fiscais_status CHECK (((status)::text = ANY ((ARRAY['emitido'::character varying, 'cancelado'::character varying])::text[]))),
    CONSTRAINT chk_cupons_fiscais_valor_total CHECK ((valor_total >= (0)::numeric))
);


--
-- Name: cupons_fiscais_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cupons_fiscais_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cupons_fiscais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cupons_fiscais_id_seq OWNED BY public.cupons_fiscais.id;


--
-- Name: enderecos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.enderecos (
    id bigint NOT NULL,
    logradouro character varying NOT NULL,
    numero character varying NOT NULL,
    complemento character varying,
    bairro character varying NOT NULL,
    cidade character varying NOT NULL,
    estado character varying(2) NOT NULL,
    cep character varying(8) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_enderecos_cep_length CHECK ((char_length((cep)::text) = 8)),
    CONSTRAINT chk_enderecos_estado_length CHECK ((char_length((estado)::text) = 2))
);


--
-- Name: enderecos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.enderecos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enderecos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.enderecos_id_seq OWNED BY public.enderecos.id;


--
-- Name: escalas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.escalas (
    id bigint NOT NULL,
    funcionario_id bigint NOT NULL,
    turno_id bigint NOT NULL,
    data date NOT NULL,
    status character varying DEFAULT 'prevista'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_escalas_status CHECK (((status)::text = ANY ((ARRAY['prevista'::character varying, 'realizada'::character varying, 'cancelada'::character varying])::text[])))
);


--
-- Name: escalas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.escalas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: escalas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.escalas_id_seq OWNED BY public.escalas.id;


--
-- Name: estoques; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estoques (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    quantidade numeric(12,3) DEFAULT 0.0 NOT NULL,
    quantidade_minima numeric(12,3) DEFAULT 0.0 NOT NULL,
    localizacao character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_estoques_quantidade CHECK ((quantidade >= (0)::numeric)),
    CONSTRAINT chk_estoques_quantidade_minima CHECK ((quantidade_minima >= (0)::numeric))
);


--
-- Name: estoques_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.estoques_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: estoques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.estoques_id_seq OWNED BY public.estoques.id;


--
-- Name: fechamento_caixas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fechamento_caixas (
    id bigint NOT NULL,
    caixa_id bigint NOT NULL,
    funcionario_id bigint NOT NULL,
    fechado_em timestamp(6) without time zone NOT NULL,
    valor_informado numeric(14,2) NOT NULL,
    valor_sistema numeric(14,2) NOT NULL,
    diferenca numeric(14,2) DEFAULT 0.0 NOT NULL,
    observacoes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_fechamento_caixas_valor_informado CHECK ((valor_informado >= (0)::numeric)),
    CONSTRAINT chk_fechamento_caixas_valor_sistema CHECK ((valor_sistema >= (0)::numeric))
);


--
-- Name: fechamento_caixas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fechamento_caixas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fechamento_caixas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fechamento_caixas_id_seq OWNED BY public.fechamento_caixas.id;


--
-- Name: formas_pagamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.formas_pagamento (
    id bigint NOT NULL,
    chave character varying NOT NULL,
    nome character varying NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: formas_pagamento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.formas_pagamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: formas_pagamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.formas_pagamento_id_seq OWNED BY public.formas_pagamento.id;


--
-- Name: fornecedores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fornecedores (
    id bigint NOT NULL,
    endereco_id bigint,
    razao_social character varying NOT NULL,
    nome_fantasia character varying,
    cnpj character varying(14) NOT NULL,
    inscricao_estadual character varying,
    email character varying,
    telefone character varying,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_fornecedores_cnpj_length CHECK ((char_length((cnpj)::text) = 14))
);


--
-- Name: fornecedores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fornecedores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fornecedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fornecedores_id_seq OWNED BY public.fornecedores.id;


--
-- Name: frotas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.frotas (
    id bigint NOT NULL,
    cliente_id bigint NOT NULL,
    nome character varying NOT NULL,
    codigo character varying NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: frotas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.frotas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frotas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.frotas_id_seq OWNED BY public.frotas.id;


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.funcionarios (
    id bigint NOT NULL,
    endereco_id bigint,
    cargo_id bigint NOT NULL,
    nome character varying NOT NULL,
    cpf character varying(11) NOT NULL,
    email character varying,
    telefone character varying,
    data_admissao date NOT NULL,
    data_demissao date,
    salario numeric(12,2) DEFAULT 0.0 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_funcionarios_cpf_length CHECK ((char_length((cpf)::text) = 11)),
    CONSTRAINT chk_funcionarios_datas CHECK (((data_demissao IS NULL) OR (data_demissao >= data_admissao))),
    CONSTRAINT chk_funcionarios_salario_non_negative CHECK ((salario >= (0)::numeric))
);


--
-- Name: funcionarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.funcionarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: funcionarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.funcionarios_id_seq OWNED BY public.funcionarios.id;


--
-- Name: historico_precos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historico_precos (
    id bigint NOT NULL,
    combustivel_id bigint NOT NULL,
    preco numeric(10,3) NOT NULL,
    vigente_em timestamp(6) without time zone NOT NULL,
    encerrado_em timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_historico_precos_periodo CHECK (((encerrado_em IS NULL) OR (encerrado_em > vigente_em))),
    CONSTRAINT chk_historico_precos_preco_positive CHECK ((preco > (0)::numeric))
);


--
-- Name: historico_precos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.historico_precos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historico_precos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.historico_precos_id_seq OWNED BY public.historico_precos.id;


--
-- Name: leituras_encerrantes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leituras_encerrantes (
    id bigint NOT NULL,
    bico_id bigint NOT NULL,
    funcionario_id bigint NOT NULL,
    encerrante_litros numeric(14,3) NOT NULL,
    lida_em timestamp(6) without time zone NOT NULL,
    observacoes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_leituras_encerrantes_valor CHECK ((encerrante_litros >= (0)::numeric))
);


--
-- Name: leituras_encerrantes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leituras_encerrantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leituras_encerrantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leituras_encerrantes_id_seq OWNED BY public.leituras_encerrantes.id;


--
-- Name: manutencoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manutencoes (
    id bigint NOT NULL,
    tanque_id bigint,
    bomba_id bigint,
    bico_id bigint,
    tipo character varying NOT NULL,
    descricao text NOT NULL,
    iniciada_em timestamp(6) without time zone NOT NULL,
    finalizada_em timestamp(6) without time zone,
    custo numeric(12,2) DEFAULT 0.0 NOT NULL,
    status character varying DEFAULT 'aberta'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_manutencoes_custo_non_negative CHECK ((custo >= (0)::numeric)),
    CONSTRAINT chk_manutencoes_periodo CHECK (((finalizada_em IS NULL) OR (finalizada_em >= iniciada_em))),
    CONSTRAINT chk_manutencoes_status CHECK (((status)::text = ANY ((ARRAY['aberta'::character varying, 'concluida'::character varying, 'cancelada'::character varying])::text[]))),
    CONSTRAINT chk_manutencoes_um_equipamento CHECK ((num_nonnulls(tanque_id, bomba_id, bico_id) = 1))
);


--
-- Name: manutencoes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manutencoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manutencoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manutencoes_id_seq OWNED BY public.manutencoes.id;


--
-- Name: movimentacao_estoques; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.movimentacao_estoques (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    funcionario_id bigint,
    tipo character varying NOT NULL,
    quantidade numeric(12,3) NOT NULL,
    saldo_apos numeric(12,3) NOT NULL,
    origem character varying,
    observacoes text,
    movimentada_em timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_movimentacao_estoques_quantidade CHECK ((quantidade <> (0)::numeric)),
    CONSTRAINT chk_movimentacao_estoques_saldo CHECK ((saldo_apos >= (0)::numeric)),
    CONSTRAINT chk_movimentacao_estoques_tipo CHECK (((tipo)::text = ANY ((ARRAY['entrada'::character varying, 'saida'::character varying, 'ajuste'::character varying])::text[])))
);


--
-- Name: movimentacao_estoques_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.movimentacao_estoques_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movimentacao_estoques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.movimentacao_estoques_id_seq OWNED BY public.movimentacao_estoques.id;


--
-- Name: movimentacao_tanques; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.movimentacao_tanques (
    id bigint NOT NULL,
    tanque_id bigint NOT NULL,
    combustivel_id bigint NOT NULL,
    venda_item_id bigint,
    tipo character varying NOT NULL,
    volume_litros numeric(12,3) NOT NULL,
    saldo_apos_litros numeric(12,3) NOT NULL,
    movimentada_em timestamp(6) without time zone NOT NULL,
    observacoes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_movimentacao_tanques_saldo CHECK ((saldo_apos_litros >= (0)::numeric)),
    CONSTRAINT chk_movimentacao_tanques_tipo CHECK (((tipo)::text = ANY ((ARRAY['entrada'::character varying, 'saida'::character varying, 'ajuste'::character varying])::text[]))),
    CONSTRAINT chk_movimentacao_tanques_volume CHECK ((volume_litros <> (0)::numeric))
);


--
-- Name: movimentacao_tanques_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.movimentacao_tanques_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: movimentacao_tanques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.movimentacao_tanques_id_seq OWNED BY public.movimentacao_tanques.id;


--
-- Name: nota_fiscal_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nota_fiscal_itens (
    id bigint NOT NULL,
    nota_fiscal_id bigint NOT NULL,
    produto_id bigint NOT NULL,
    quantidade numeric(12,3) NOT NULL,
    valor_unitario numeric(12,2) NOT NULL,
    valor_total numeric(14,2) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_nota_fiscal_itens_quantidade CHECK ((quantidade > (0)::numeric)),
    CONSTRAINT chk_nota_fiscal_itens_valor_total CHECK ((valor_total >= (0)::numeric)),
    CONSTRAINT chk_nota_fiscal_itens_valor_unitario CHECK ((valor_unitario >= (0)::numeric))
);


--
-- Name: nota_fiscal_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.nota_fiscal_itens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nota_fiscal_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.nota_fiscal_itens_id_seq OWNED BY public.nota_fiscal_itens.id;


--
-- Name: notas_fiscais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notas_fiscais (
    id bigint NOT NULL,
    fornecedor_id bigint NOT NULL,
    numero character varying NOT NULL,
    serie character varying NOT NULL,
    chave_acesso character varying(44) NOT NULL,
    data_emissao date NOT NULL,
    valor_total numeric(14,2) DEFAULT 0.0 NOT NULL,
    status character varying DEFAULT 'emitida'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_notas_fiscais_chave_length CHECK ((char_length((chave_acesso)::text) = 44)),
    CONSTRAINT chk_notas_fiscais_status CHECK (((status)::text = ANY ((ARRAY['emitida'::character varying, 'cancelada'::character varying, 'recebida'::character varying])::text[]))),
    CONSTRAINT chk_notas_fiscais_valor_total CHECK ((valor_total >= (0)::numeric))
);


--
-- Name: notas_fiscais_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notas_fiscais_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notas_fiscais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notas_fiscais_id_seq OWNED BY public.notas_fiscais.id;


--
-- Name: oleos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oleos (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    viscosidade character varying NOT NULL,
    especificacao character varying,
    volume_litros numeric(8,3) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_oleos_volume_positive CHECK ((volume_litros > (0)::numeric))
);


--
-- Name: oleos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oleos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oleos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oleos_id_seq OWNED BY public.oleos.id;


--
-- Name: pagamentos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pagamentos (
    id bigint NOT NULL,
    venda_id bigint NOT NULL,
    caixa_id bigint NOT NULL,
    forma_pagamento_id bigint,
    forma character varying NOT NULL,
    valor numeric(14,2) NOT NULL,
    status character varying DEFAULT 'pendente'::character varying NOT NULL,
    pago_em timestamp(6) without time zone,
    nsu character varying,
    codigo_autorizacao character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_pagamentos_forma CHECK (((forma)::text = ANY ((ARRAY['dinheiro'::character varying, 'cartao_credito'::character varying, 'cartao_debito'::character varying, 'pix'::character varying, 'voucher'::character varying, 'boleto'::character varying])::text[]))),
    CONSTRAINT chk_pagamentos_status CHECK (((status)::text = ANY ((ARRAY['pendente'::character varying, 'aprovado'::character varying, 'recusado'::character varying, 'cancelado'::character varying, 'estornado'::character varying])::text[]))),
    CONSTRAINT chk_pagamentos_valor CHECK ((valor > (0)::numeric))
);


--
-- Name: pagamentos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pagamentos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pagamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pagamentos_id_seq OWNED BY public.pagamentos.id;


--
-- Name: parcelas_receber; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parcelas_receber (
    id bigint NOT NULL,
    conta_receber_id bigint NOT NULL,
    numero integer NOT NULL,
    valor numeric(14,2) NOT NULL,
    saldo numeric(14,2) NOT NULL,
    vencimento_em date NOT NULL,
    paga_em timestamp(6) without time zone,
    status character varying DEFAULT 'aberta'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_parcelas_receber_numero CHECK ((numero > 0)),
    CONSTRAINT chk_parcelas_receber_saldo CHECK ((saldo >= (0)::numeric)),
    CONSTRAINT chk_parcelas_receber_saldo_valor CHECK ((saldo <= valor)),
    CONSTRAINT chk_parcelas_receber_status CHECK (((status)::text = ANY ((ARRAY['aberta'::character varying, 'paga'::character varying, 'vencida'::character varying, 'cancelada'::character varying])::text[]))),
    CONSTRAINT chk_parcelas_receber_valor CHECK ((valor > (0)::numeric))
);


--
-- Name: parcelas_receber_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parcelas_receber_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parcelas_receber_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.parcelas_receber_id_seq OWNED BY public.parcelas_receber.id;


--
-- Name: permissoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissoes (
    id bigint NOT NULL,
    chave character varying NOT NULL,
    nome character varying NOT NULL,
    descricao text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: permissoes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permissoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permissoes_id_seq OWNED BY public.permissoes.id;


--
-- Name: produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produtos (
    id bigint NOT NULL,
    categoria_id bigint NOT NULL,
    nome character varying NOT NULL,
    sku character varying NOT NULL,
    codigo_barras character varying,
    unidade_medida character varying DEFAULT 'unidade'::character varying NOT NULL,
    preco_venda numeric(12,2) NOT NULL,
    custo_medio numeric(12,2) DEFAULT 0.0 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_produtos_custo_medio CHECK ((custo_medio >= (0)::numeric)),
    CONSTRAINT chk_produtos_preco_venda CHECK ((preco_venda >= (0)::numeric))
);


--
-- Name: produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.produtos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.produtos_id_seq OWNED BY public.produtos.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tanques; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tanques (
    id bigint NOT NULL,
    combustivel_id bigint NOT NULL,
    codigo character varying NOT NULL,
    capacidade_litros numeric(12,3) NOT NULL,
    volume_atual_litros numeric(12,3) DEFAULT 0.0 NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_tanques_capacidade_positive CHECK ((capacidade_litros > (0)::numeric)),
    CONSTRAINT chk_tanques_volume_capacity CHECK ((volume_atual_litros <= capacidade_litros)),
    CONSTRAINT chk_tanques_volume_non_negative CHECK ((volume_atual_litros >= (0)::numeric))
);


--
-- Name: tanques_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tanques_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tanques_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tanques_id_seq OWNED BY public.tanques.id;


--
-- Name: turnos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.turnos (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    hora_inicio time without time zone NOT NULL,
    hora_fim time without time zone NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: turnos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.turnos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: turnos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.turnos_id_seq OWNED BY public.turnos.id;


--
-- Name: veiculos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.veiculos (
    id bigint NOT NULL,
    cliente_id bigint,
    frota_id bigint,
    placa character varying(7) NOT NULL,
    marca character varying,
    modelo character varying,
    ano integer,
    cor character varying,
    tipo character varying,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_veiculos_ano CHECK (((ano IS NULL) OR ((ano >= 1900) AND (ano <= 2100)))),
    CONSTRAINT chk_veiculos_placa_length CHECK ((char_length((placa)::text) = 7)),
    CONSTRAINT chk_veiculos_proprietario CHECK ((num_nonnulls(cliente_id, frota_id) >= 1))
);


--
-- Name: veiculos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.veiculos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: veiculos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.veiculos_id_seq OWNED BY public.veiculos.id;


--
-- Name: venda_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venda_itens (
    id bigint NOT NULL,
    venda_id bigint NOT NULL,
    produto_id bigint,
    combustivel_id bigint,
    bico_id bigint,
    descricao character varying NOT NULL,
    quantidade numeric(12,3) NOT NULL,
    valor_unitario numeric(12,3) NOT NULL,
    desconto numeric(12,2) DEFAULT 0.0 NOT NULL,
    total numeric(14,2) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_venda_itens_bico_combustivel CHECK (((bico_id IS NULL) OR (combustivel_id IS NOT NULL))),
    CONSTRAINT chk_venda_itens_desconto CHECK ((desconto >= (0)::numeric)),
    CONSTRAINT chk_venda_itens_quantidade CHECK ((quantidade > (0)::numeric)),
    CONSTRAINT chk_venda_itens_tipo_item CHECK ((((produto_id IS NOT NULL) AND (combustivel_id IS NULL)) OR ((produto_id IS NULL) AND (combustivel_id IS NOT NULL)))),
    CONSTRAINT chk_venda_itens_total CHECK ((total >= (0)::numeric)),
    CONSTRAINT chk_venda_itens_valor_unitario CHECK ((valor_unitario >= (0)::numeric))
);


--
-- Name: venda_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venda_itens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venda_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venda_itens_id_seq OWNED BY public.venda_itens.id;


--
-- Name: vendas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendas (
    id bigint NOT NULL,
    cliente_id bigint,
    funcionario_id bigint NOT NULL,
    caixa_id bigint NOT NULL,
    veiculo_id bigint,
    numero character varying NOT NULL,
    vendida_em timestamp(6) without time zone NOT NULL,
    subtotal numeric(14,2) DEFAULT 0.0 NOT NULL,
    desconto numeric(14,2) DEFAULT 0.0 NOT NULL,
    total numeric(14,2) DEFAULT 0.0 NOT NULL,
    status character varying DEFAULT 'aberta'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT chk_vendas_desconto CHECK ((desconto >= (0)::numeric)),
    CONSTRAINT chk_vendas_desconto_subtotal CHECK ((desconto <= subtotal)),
    CONSTRAINT chk_vendas_status CHECK (((status)::text = ANY ((ARRAY['aberta'::character varying, 'finalizada'::character varying, 'cancelada'::character varying])::text[]))),
    CONSTRAINT chk_vendas_subtotal CHECK ((subtotal >= (0)::numeric)),
    CONSTRAINT chk_vendas_total CHECK ((total >= (0)::numeric))
);


--
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- Name: afericoes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afericoes ALTER COLUMN id SET DEFAULT nextval('public.afericoes_id_seq'::regclass);


--
-- Name: auditoria_eventos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria_eventos ALTER COLUMN id SET DEFAULT nextval('public.auditoria_eventos_id_seq'::regclass);


--
-- Name: bicos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bicos ALTER COLUMN id SET DEFAULT nextval('public.bicos_id_seq'::regclass);


--
-- Name: bombas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bombas ALTER COLUMN id SET DEFAULT nextval('public.bombas_id_seq'::regclass);


--
-- Name: caixas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caixas ALTER COLUMN id SET DEFAULT nextval('public.caixas_id_seq'::regclass);


--
-- Name: calibracoes_bicos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibracoes_bicos ALTER COLUMN id SET DEFAULT nextval('public.calibracoes_bicos_id_seq'::regclass);


--
-- Name: cargo_permissoes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargo_permissoes ALTER COLUMN id SET DEFAULT nextval('public.cargo_permissoes_id_seq'::regclass);


--
-- Name: cargos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargos ALTER COLUMN id SET DEFAULT nextval('public.cargos_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: cliente_pessoas_fisicas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente_pessoas_fisicas ALTER COLUMN id SET DEFAULT nextval('public.cliente_pessoas_fisicas_id_seq'::regclass);


--
-- Name: cliente_pessoas_juridicas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente_pessoas_juridicas ALTER COLUMN id SET DEFAULT nextval('public.cliente_pessoas_juridicas_id_seq'::regclass);


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: combustiveis id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.combustiveis ALTER COLUMN id SET DEFAULT nextval('public.combustiveis_id_seq'::regclass);


--
-- Name: contas_receber id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_receber ALTER COLUMN id SET DEFAULT nextval('public.contas_receber_id_seq'::regclass);


--
-- Name: cupons_fiscais id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cupons_fiscais ALTER COLUMN id SET DEFAULT nextval('public.cupons_fiscais_id_seq'::regclass);


--
-- Name: enderecos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enderecos ALTER COLUMN id SET DEFAULT nextval('public.enderecos_id_seq'::regclass);


--
-- Name: escalas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.escalas ALTER COLUMN id SET DEFAULT nextval('public.escalas_id_seq'::regclass);


--
-- Name: estoques id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estoques ALTER COLUMN id SET DEFAULT nextval('public.estoques_id_seq'::regclass);


--
-- Name: fechamento_caixas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fechamento_caixas ALTER COLUMN id SET DEFAULT nextval('public.fechamento_caixas_id_seq'::regclass);


--
-- Name: formas_pagamento id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.formas_pagamento ALTER COLUMN id SET DEFAULT nextval('public.formas_pagamento_id_seq'::regclass);


--
-- Name: fornecedores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fornecedores ALTER COLUMN id SET DEFAULT nextval('public.fornecedores_id_seq'::regclass);


--
-- Name: frotas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frotas ALTER COLUMN id SET DEFAULT nextval('public.frotas_id_seq'::regclass);


--
-- Name: funcionarios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios ALTER COLUMN id SET DEFAULT nextval('public.funcionarios_id_seq'::regclass);


--
-- Name: historico_precos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historico_precos ALTER COLUMN id SET DEFAULT nextval('public.historico_precos_id_seq'::regclass);


--
-- Name: leituras_encerrantes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leituras_encerrantes ALTER COLUMN id SET DEFAULT nextval('public.leituras_encerrantes_id_seq'::regclass);


--
-- Name: manutencoes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manutencoes ALTER COLUMN id SET DEFAULT nextval('public.manutencoes_id_seq'::regclass);


--
-- Name: movimentacao_estoques id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_estoques ALTER COLUMN id SET DEFAULT nextval('public.movimentacao_estoques_id_seq'::regclass);


--
-- Name: movimentacao_tanques id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_tanques ALTER COLUMN id SET DEFAULT nextval('public.movimentacao_tanques_id_seq'::regclass);


--
-- Name: nota_fiscal_itens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nota_fiscal_itens ALTER COLUMN id SET DEFAULT nextval('public.nota_fiscal_itens_id_seq'::regclass);


--
-- Name: notas_fiscais id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notas_fiscais ALTER COLUMN id SET DEFAULT nextval('public.notas_fiscais_id_seq'::regclass);


--
-- Name: oleos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oleos ALTER COLUMN id SET DEFAULT nextval('public.oleos_id_seq'::regclass);


--
-- Name: pagamentos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pagamentos ALTER COLUMN id SET DEFAULT nextval('public.pagamentos_id_seq'::regclass);


--
-- Name: parcelas_receber id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parcelas_receber ALTER COLUMN id SET DEFAULT nextval('public.parcelas_receber_id_seq'::regclass);


--
-- Name: permissoes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissoes ALTER COLUMN id SET DEFAULT nextval('public.permissoes_id_seq'::regclass);


--
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produtos_id_seq'::regclass);


--
-- Name: tanques id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tanques ALTER COLUMN id SET DEFAULT nextval('public.tanques_id_seq'::regclass);


--
-- Name: turnos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turnos ALTER COLUMN id SET DEFAULT nextval('public.turnos_id_seq'::regclass);


--
-- Name: veiculos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.veiculos ALTER COLUMN id SET DEFAULT nextval('public.veiculos_id_seq'::regclass);


--
-- Name: venda_itens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venda_itens ALTER COLUMN id SET DEFAULT nextval('public.venda_itens_id_seq'::regclass);


--
-- Name: vendas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- Name: afericoes afericoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afericoes
    ADD CONSTRAINT afericoes_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: auditoria_eventos auditoria_eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria_eventos
    ADD CONSTRAINT auditoria_eventos_pkey PRIMARY KEY (id);


--
-- Name: bicos bicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bicos
    ADD CONSTRAINT bicos_pkey PRIMARY KEY (id);


--
-- Name: bombas bombas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bombas
    ADD CONSTRAINT bombas_pkey PRIMARY KEY (id);


--
-- Name: caixas caixas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caixas
    ADD CONSTRAINT caixas_pkey PRIMARY KEY (id);


--
-- Name: calibracoes_bicos calibracoes_bicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibracoes_bicos
    ADD CONSTRAINT calibracoes_bicos_pkey PRIMARY KEY (id);


--
-- Name: cargo_permissoes cargo_permissoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargo_permissoes
    ADD CONSTRAINT cargo_permissoes_pkey PRIMARY KEY (id);


--
-- Name: cargos cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: cliente_pessoas_fisicas cliente_pessoas_fisicas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente_pessoas_fisicas
    ADD CONSTRAINT cliente_pessoas_fisicas_pkey PRIMARY KEY (id);


--
-- Name: cliente_pessoas_juridicas cliente_pessoas_juridicas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente_pessoas_juridicas
    ADD CONSTRAINT cliente_pessoas_juridicas_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: combustiveis combustiveis_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.combustiveis
    ADD CONSTRAINT combustiveis_pkey PRIMARY KEY (id);


--
-- Name: contas_receber contas_receber_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_receber
    ADD CONSTRAINT contas_receber_pkey PRIMARY KEY (id);


--
-- Name: cupons_fiscais cupons_fiscais_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cupons_fiscais
    ADD CONSTRAINT cupons_fiscais_pkey PRIMARY KEY (id);


--
-- Name: enderecos enderecos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT enderecos_pkey PRIMARY KEY (id);


--
-- Name: escalas escalas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT escalas_pkey PRIMARY KEY (id);


--
-- Name: estoques estoques_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estoques
    ADD CONSTRAINT estoques_pkey PRIMARY KEY (id);


--
-- Name: fechamento_caixas fechamento_caixas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fechamento_caixas
    ADD CONSTRAINT fechamento_caixas_pkey PRIMARY KEY (id);


--
-- Name: formas_pagamento formas_pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.formas_pagamento
    ADD CONSTRAINT formas_pagamento_pkey PRIMARY KEY (id);


--
-- Name: fornecedores fornecedores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (id);


--
-- Name: frotas frotas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frotas
    ADD CONSTRAINT frotas_pkey PRIMARY KEY (id);


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (id);


--
-- Name: historico_precos historico_precos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historico_precos
    ADD CONSTRAINT historico_precos_pkey PRIMARY KEY (id);


--
-- Name: leituras_encerrantes leituras_encerrantes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leituras_encerrantes
    ADD CONSTRAINT leituras_encerrantes_pkey PRIMARY KEY (id);


--
-- Name: manutencoes manutencoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manutencoes
    ADD CONSTRAINT manutencoes_pkey PRIMARY KEY (id);


--
-- Name: movimentacao_estoques movimentacao_estoques_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_estoques
    ADD CONSTRAINT movimentacao_estoques_pkey PRIMARY KEY (id);


--
-- Name: movimentacao_tanques movimentacao_tanques_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_tanques
    ADD CONSTRAINT movimentacao_tanques_pkey PRIMARY KEY (id);


--
-- Name: nota_fiscal_itens nota_fiscal_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nota_fiscal_itens
    ADD CONSTRAINT nota_fiscal_itens_pkey PRIMARY KEY (id);


--
-- Name: notas_fiscais notas_fiscais_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notas_fiscais
    ADD CONSTRAINT notas_fiscais_pkey PRIMARY KEY (id);


--
-- Name: oleos oleos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oleos
    ADD CONSTRAINT oleos_pkey PRIMARY KEY (id);


--
-- Name: pagamentos pagamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pagamentos
    ADD CONSTRAINT pagamentos_pkey PRIMARY KEY (id);


--
-- Name: parcelas_receber parcelas_receber_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parcelas_receber
    ADD CONSTRAINT parcelas_receber_pkey PRIMARY KEY (id);


--
-- Name: permissoes permissoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissoes
    ADD CONSTRAINT permissoes_pkey PRIMARY KEY (id);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tanques tanques_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tanques
    ADD CONSTRAINT tanques_pkey PRIMARY KEY (id);


--
-- Name: turnos turnos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.turnos
    ADD CONSTRAINT turnos_pkey PRIMARY KEY (id);


--
-- Name: veiculos veiculos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.veiculos
    ADD CONSTRAINT veiculos_pkey PRIMARY KEY (id);


--
-- Name: venda_itens venda_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT venda_itens_pkey PRIMARY KEY (id);


--
-- Name: vendas vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- Name: index_afericoes_on_bico_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_afericoes_on_bico_id ON public.afericoes USING btree (bico_id);


--
-- Name: index_afericoes_on_bico_id_and_realizada_em; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_afericoes_on_bico_id_and_realizada_em ON public.afericoes USING btree (bico_id, realizada_em);


--
-- Name: index_afericoes_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_afericoes_on_funcionario_id ON public.afericoes USING btree (funcionario_id);


--
-- Name: index_auditoria_eventos_on_entidade_and_entidade_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auditoria_eventos_on_entidade_and_entidade_id ON public.auditoria_eventos USING btree (entidade, entidade_id);


--
-- Name: index_auditoria_eventos_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auditoria_eventos_on_funcionario_id ON public.auditoria_eventos USING btree (funcionario_id);


--
-- Name: index_auditoria_eventos_on_ocorrido_em; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auditoria_eventos_on_ocorrido_em ON public.auditoria_eventos USING btree (ocorrido_em);


--
-- Name: index_bicos_on_bomba_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bicos_on_bomba_id ON public.bicos USING btree (bomba_id);


--
-- Name: index_bicos_on_bomba_id_and_numero; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bicos_on_bomba_id_and_numero ON public.bicos USING btree (bomba_id, numero);


--
-- Name: index_bicos_on_codigo; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bicos_on_codigo ON public.bicos USING btree (codigo);


--
-- Name: index_bicos_on_tanque_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bicos_on_tanque_id ON public.bicos USING btree (tanque_id);


--
-- Name: index_bombas_on_codigo; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bombas_on_codigo ON public.bombas USING btree (codigo);


--
-- Name: index_caixas_on_escala_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_caixas_on_escala_id ON public.caixas USING btree (escala_id);


--
-- Name: index_caixas_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_caixas_on_funcionario_id ON public.caixas USING btree (funcionario_id);


--
-- Name: index_calibracoes_bicos_on_bico_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calibracoes_bicos_on_bico_id ON public.calibracoes_bicos USING btree (bico_id);


--
-- Name: index_calibracoes_bicos_on_bico_id_and_realizada_em; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_calibracoes_bicos_on_bico_id_and_realizada_em ON public.calibracoes_bicos USING btree (bico_id, realizada_em);


--
-- Name: index_calibracoes_bicos_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calibracoes_bicos_on_funcionario_id ON public.calibracoes_bicos USING btree (funcionario_id);


--
-- Name: index_cargo_permissoes_on_cargo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cargo_permissoes_on_cargo_id ON public.cargo_permissoes USING btree (cargo_id);


--
-- Name: index_cargo_permissoes_on_cargo_id_and_permissao_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cargo_permissoes_on_cargo_id_and_permissao_id ON public.cargo_permissoes USING btree (cargo_id, permissao_id);


--
-- Name: index_cargo_permissoes_on_permissao_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cargo_permissoes_on_permissao_id ON public.cargo_permissoes USING btree (permissao_id);


--
-- Name: index_cargos_on_nome; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cargos_on_nome ON public.cargos USING btree (nome);


--
-- Name: index_categorias_on_nome; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categorias_on_nome ON public.categorias USING btree (nome);


--
-- Name: index_cliente_pessoas_fisicas_on_cliente_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cliente_pessoas_fisicas_on_cliente_id ON public.cliente_pessoas_fisicas USING btree (cliente_id);


--
-- Name: index_cliente_pessoas_fisicas_on_cpf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cliente_pessoas_fisicas_on_cpf ON public.cliente_pessoas_fisicas USING btree (cpf);


--
-- Name: index_cliente_pessoas_juridicas_on_cliente_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cliente_pessoas_juridicas_on_cliente_id ON public.cliente_pessoas_juridicas USING btree (cliente_id);


--
-- Name: index_cliente_pessoas_juridicas_on_cnpj; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cliente_pessoas_juridicas_on_cnpj ON public.cliente_pessoas_juridicas USING btree (cnpj);


--
-- Name: index_clientes_on_endereco_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clientes_on_endereco_id ON public.clientes USING btree (endereco_id);


--
-- Name: index_clientes_on_tipo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clientes_on_tipo ON public.clientes USING btree (tipo);


--
-- Name: index_combustiveis_on_codigo_anp; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_combustiveis_on_codigo_anp ON public.combustiveis USING btree (codigo_anp);


--
-- Name: index_combustiveis_on_nome; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_combustiveis_on_nome ON public.combustiveis USING btree (nome);


--
-- Name: index_contas_receber_on_cliente_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contas_receber_on_cliente_id ON public.contas_receber USING btree (cliente_id);


--
-- Name: index_contas_receber_on_numero; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contas_receber_on_numero ON public.contas_receber USING btree (numero);


--
-- Name: index_contas_receber_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contas_receber_on_status ON public.contas_receber USING btree (status);


--
-- Name: index_contas_receber_on_venda_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contas_receber_on_venda_id ON public.contas_receber USING btree (venda_id);


--
-- Name: index_cupons_fiscais_on_chave_acesso; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cupons_fiscais_on_chave_acesso ON public.cupons_fiscais USING btree (chave_acesso);


--
-- Name: index_cupons_fiscais_on_numero_and_serie; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cupons_fiscais_on_numero_and_serie ON public.cupons_fiscais USING btree (numero, serie);


--
-- Name: index_cupons_fiscais_on_venda_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cupons_fiscais_on_venda_id ON public.cupons_fiscais USING btree (venda_id);


--
-- Name: index_enderecos_on_cep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_enderecos_on_cep ON public.enderecos USING btree (cep);


--
-- Name: index_escalas_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_escalas_on_funcionario_id ON public.escalas USING btree (funcionario_id);


--
-- Name: index_escalas_on_funcionario_id_and_turno_id_and_data; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_escalas_on_funcionario_id_and_turno_id_and_data ON public.escalas USING btree (funcionario_id, turno_id, data);


--
-- Name: index_escalas_on_turno_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_escalas_on_turno_id ON public.escalas USING btree (turno_id);


--
-- Name: index_estoques_on_produto_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_estoques_on_produto_id ON public.estoques USING btree (produto_id);


--
-- Name: index_fechamento_caixas_on_caixa_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fechamento_caixas_on_caixa_id ON public.fechamento_caixas USING btree (caixa_id);


--
-- Name: index_fechamento_caixas_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fechamento_caixas_on_funcionario_id ON public.fechamento_caixas USING btree (funcionario_id);


--
-- Name: index_formas_pagamento_on_chave; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_formas_pagamento_on_chave ON public.formas_pagamento USING btree (chave);


--
-- Name: index_fornecedores_on_cnpj; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fornecedores_on_cnpj ON public.fornecedores USING btree (cnpj);


--
-- Name: index_fornecedores_on_endereco_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fornecedores_on_endereco_id ON public.fornecedores USING btree (endereco_id);


--
-- Name: index_frotas_on_cliente_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_frotas_on_cliente_id ON public.frotas USING btree (cliente_id);


--
-- Name: index_frotas_on_cliente_id_and_codigo; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_frotas_on_cliente_id_and_codigo ON public.frotas USING btree (cliente_id, codigo);


--
-- Name: index_funcionarios_on_cargo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_funcionarios_on_cargo_id ON public.funcionarios USING btree (cargo_id);


--
-- Name: index_funcionarios_on_cpf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_funcionarios_on_cpf ON public.funcionarios USING btree (cpf);


--
-- Name: index_funcionarios_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_funcionarios_on_email ON public.funcionarios USING btree (email);


--
-- Name: index_funcionarios_on_endereco_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_funcionarios_on_endereco_id ON public.funcionarios USING btree (endereco_id);


--
-- Name: index_historico_precos_on_combustivel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_historico_precos_on_combustivel_id ON public.historico_precos USING btree (combustivel_id);


--
-- Name: index_historico_precos_on_combustivel_id_and_vigente_em; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_historico_precos_on_combustivel_id_and_vigente_em ON public.historico_precos USING btree (combustivel_id, vigente_em);


--
-- Name: index_leituras_encerrantes_on_bico_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leituras_encerrantes_on_bico_id ON public.leituras_encerrantes USING btree (bico_id);


--
-- Name: index_leituras_encerrantes_on_bico_id_and_lida_em; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_leituras_encerrantes_on_bico_id_and_lida_em ON public.leituras_encerrantes USING btree (bico_id, lida_em);


--
-- Name: index_leituras_encerrantes_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leituras_encerrantes_on_funcionario_id ON public.leituras_encerrantes USING btree (funcionario_id);


--
-- Name: index_manutencoes_on_bico_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_manutencoes_on_bico_id ON public.manutencoes USING btree (bico_id);


--
-- Name: index_manutencoes_on_bomba_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_manutencoes_on_bomba_id ON public.manutencoes USING btree (bomba_id);


--
-- Name: index_manutencoes_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_manutencoes_on_status ON public.manutencoes USING btree (status);


--
-- Name: index_manutencoes_on_tanque_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_manutencoes_on_tanque_id ON public.manutencoes USING btree (tanque_id);


--
-- Name: index_movimentacao_estoques_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movimentacao_estoques_on_funcionario_id ON public.movimentacao_estoques USING btree (funcionario_id);


--
-- Name: index_movimentacao_estoques_on_movimentada_em; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movimentacao_estoques_on_movimentada_em ON public.movimentacao_estoques USING btree (movimentada_em);


--
-- Name: index_movimentacao_estoques_on_produto_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movimentacao_estoques_on_produto_id ON public.movimentacao_estoques USING btree (produto_id);


--
-- Name: index_movimentacao_tanques_on_combustivel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movimentacao_tanques_on_combustivel_id ON public.movimentacao_tanques USING btree (combustivel_id);


--
-- Name: index_movimentacao_tanques_on_movimentada_em; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movimentacao_tanques_on_movimentada_em ON public.movimentacao_tanques USING btree (movimentada_em);


--
-- Name: index_movimentacao_tanques_on_tanque_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movimentacao_tanques_on_tanque_id ON public.movimentacao_tanques USING btree (tanque_id);


--
-- Name: index_movimentacao_tanques_on_venda_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_movimentacao_tanques_on_venda_item_id ON public.movimentacao_tanques USING btree (venda_item_id);


--
-- Name: index_nota_fiscal_itens_on_nota_fiscal_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nota_fiscal_itens_on_nota_fiscal_id ON public.nota_fiscal_itens USING btree (nota_fiscal_id);


--
-- Name: index_nota_fiscal_itens_on_produto_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nota_fiscal_itens_on_produto_id ON public.nota_fiscal_itens USING btree (produto_id);


--
-- Name: index_notas_fiscais_on_chave_acesso; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_notas_fiscais_on_chave_acesso ON public.notas_fiscais USING btree (chave_acesso);


--
-- Name: index_notas_fiscais_on_fornecedor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notas_fiscais_on_fornecedor_id ON public.notas_fiscais USING btree (fornecedor_id);


--
-- Name: index_notas_fiscais_on_fornecedor_id_and_numero_and_serie; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_notas_fiscais_on_fornecedor_id_and_numero_and_serie ON public.notas_fiscais USING btree (fornecedor_id, numero, serie);


--
-- Name: index_oleos_on_produto_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oleos_on_produto_id ON public.oleos USING btree (produto_id);


--
-- Name: index_pagamentos_on_caixa_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pagamentos_on_caixa_id ON public.pagamentos USING btree (caixa_id);


--
-- Name: index_pagamentos_on_forma_pagamento_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pagamentos_on_forma_pagamento_id ON public.pagamentos USING btree (forma_pagamento_id);


--
-- Name: index_pagamentos_on_venda_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pagamentos_on_venda_id ON public.pagamentos USING btree (venda_id);


--
-- Name: index_pagamentos_on_venda_id_and_forma; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pagamentos_on_venda_id_and_forma ON public.pagamentos USING btree (venda_id, forma);


--
-- Name: index_parcelas_receber_on_conta_receber_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parcelas_receber_on_conta_receber_id ON public.parcelas_receber USING btree (conta_receber_id);


--
-- Name: index_parcelas_receber_on_conta_receber_id_and_numero; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_parcelas_receber_on_conta_receber_id_and_numero ON public.parcelas_receber USING btree (conta_receber_id, numero);


--
-- Name: index_parcelas_receber_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parcelas_receber_on_status ON public.parcelas_receber USING btree (status);


--
-- Name: index_permissoes_on_chave; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_permissoes_on_chave ON public.permissoes USING btree (chave);


--
-- Name: index_produtos_on_categoria_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_produtos_on_categoria_id ON public.produtos USING btree (categoria_id);


--
-- Name: index_produtos_on_codigo_barras; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_produtos_on_codigo_barras ON public.produtos USING btree (codigo_barras);


--
-- Name: index_produtos_on_sku; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_produtos_on_sku ON public.produtos USING btree (sku);


--
-- Name: index_tanques_on_codigo; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tanques_on_codigo ON public.tanques USING btree (codigo);


--
-- Name: index_tanques_on_combustivel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tanques_on_combustivel_id ON public.tanques USING btree (combustivel_id);


--
-- Name: index_turnos_on_nome; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_turnos_on_nome ON public.turnos USING btree (nome);


--
-- Name: index_veiculos_on_cliente_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_veiculos_on_cliente_id ON public.veiculos USING btree (cliente_id);


--
-- Name: index_veiculos_on_frota_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_veiculos_on_frota_id ON public.veiculos USING btree (frota_id);


--
-- Name: index_veiculos_on_placa; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_veiculos_on_placa ON public.veiculos USING btree (placa);


--
-- Name: index_venda_itens_on_bico_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venda_itens_on_bico_id ON public.venda_itens USING btree (bico_id);


--
-- Name: index_venda_itens_on_combustivel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venda_itens_on_combustivel_id ON public.venda_itens USING btree (combustivel_id);


--
-- Name: index_venda_itens_on_produto_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venda_itens_on_produto_id ON public.venda_itens USING btree (produto_id);


--
-- Name: index_venda_itens_on_venda_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venda_itens_on_venda_id ON public.venda_itens USING btree (venda_id);


--
-- Name: index_vendas_on_caixa_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendas_on_caixa_id ON public.vendas USING btree (caixa_id);


--
-- Name: index_vendas_on_cliente_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendas_on_cliente_id ON public.vendas USING btree (cliente_id);


--
-- Name: index_vendas_on_funcionario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendas_on_funcionario_id ON public.vendas USING btree (funcionario_id);


--
-- Name: index_vendas_on_numero; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vendas_on_numero ON public.vendas USING btree (numero);


--
-- Name: index_vendas_on_veiculo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendas_on_veiculo_id ON public.vendas USING btree (veiculo_id);


--
-- Name: index_vendas_on_vendida_em; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendas_on_vendida_em ON public.vendas USING btree (vendida_em);


--
-- Name: afericoes fk_rails_172502b55c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afericoes
    ADD CONSTRAINT fk_rails_172502b55c FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: cargo_permissoes fk_rails_1801baca4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargo_permissoes
    ADD CONSTRAINT fk_rails_1801baca4d FOREIGN KEY (permissao_id) REFERENCES public.permissoes(id);


--
-- Name: caixas fk_rails_1d2469f2a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caixas
    ADD CONSTRAINT fk_rails_1d2469f2a7 FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: leituras_encerrantes fk_rails_21a6a33e0d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leituras_encerrantes
    ADD CONSTRAINT fk_rails_21a6a33e0d FOREIGN KEY (bico_id) REFERENCES public.bicos(id);


--
-- Name: frotas fk_rails_269f89aea1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.frotas
    ADD CONSTRAINT fk_rails_269f89aea1 FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: vendas fk_rails_27aa611636; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_rails_27aa611636 FOREIGN KEY (caixa_id) REFERENCES public.caixas(id);


--
-- Name: venda_itens fk_rails_3c301e23aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT fk_rails_3c301e23aa FOREIGN KEY (bico_id) REFERENCES public.bicos(id);


--
-- Name: contas_receber fk_rails_3ff85e665b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_receber
    ADD CONSTRAINT fk_rails_3ff85e665b FOREIGN KEY (venda_id) REFERENCES public.vendas(id);


--
-- Name: afericoes fk_rails_40c0de7e90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.afericoes
    ADD CONSTRAINT fk_rails_40c0de7e90 FOREIGN KEY (bico_id) REFERENCES public.bicos(id);


--
-- Name: estoques fk_rails_4226040c9f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estoques
    ADD CONSTRAINT fk_rails_4226040c9f FOREIGN KEY (produto_id) REFERENCES public.produtos(id);


--
-- Name: veiculos fk_rails_4319fde347; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.veiculos
    ADD CONSTRAINT fk_rails_4319fde347 FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: bicos fk_rails_4796eee9a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bicos
    ADD CONSTRAINT fk_rails_4796eee9a3 FOREIGN KEY (bomba_id) REFERENCES public.bombas(id);


--
-- Name: vendas fk_rails_540c540d99; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_rails_540c540d99 FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: movimentacao_tanques fk_rails_5d6f7467cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_tanques
    ADD CONSTRAINT fk_rails_5d6f7467cf FOREIGN KEY (tanque_id) REFERENCES public.tanques(id);


--
-- Name: escalas fk_rails_5e55d24e8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT fk_rails_5e55d24e8b FOREIGN KEY (turno_id) REFERENCES public.turnos(id);


--
-- Name: fechamento_caixas fk_rails_5f4e2a41b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fechamento_caixas
    ADD CONSTRAINT fk_rails_5f4e2a41b6 FOREIGN KEY (caixa_id) REFERENCES public.caixas(id);


--
-- Name: cliente_pessoas_fisicas fk_rails_61bf8a271f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente_pessoas_fisicas
    ADD CONSTRAINT fk_rails_61bf8a271f FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: contas_receber fk_rails_61fd80cc49; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contas_receber
    ADD CONSTRAINT fk_rails_61fd80cc49 FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: vendas fk_rails_691d621368; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_rails_691d621368 FOREIGN KEY (veiculo_id) REFERENCES public.veiculos(id);


--
-- Name: movimentacao_tanques fk_rails_72ef83bb25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_tanques
    ADD CONSTRAINT fk_rails_72ef83bb25 FOREIGN KEY (venda_item_id) REFERENCES public.venda_itens(id);


--
-- Name: calibracoes_bicos fk_rails_80861ec6ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibracoes_bicos
    ADD CONSTRAINT fk_rails_80861ec6ed FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: parcelas_receber fk_rails_8e8edb4ff5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parcelas_receber
    ADD CONSTRAINT fk_rails_8e8edb4ff5 FOREIGN KEY (conta_receber_id) REFERENCES public.contas_receber(id);


--
-- Name: nota_fiscal_itens fk_rails_92f0d43692; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nota_fiscal_itens
    ADD CONSTRAINT fk_rails_92f0d43692 FOREIGN KEY (produto_id) REFERENCES public.produtos(id);


--
-- Name: veiculos fk_rails_98e2138428; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.veiculos
    ADD CONSTRAINT fk_rails_98e2138428 FOREIGN KEY (frota_id) REFERENCES public.frotas(id);


--
-- Name: movimentacao_tanques fk_rails_9b1c33e71e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_tanques
    ADD CONSTRAINT fk_rails_9b1c33e71e FOREIGN KEY (combustivel_id) REFERENCES public.combustiveis(id);


--
-- Name: venda_itens fk_rails_9e8368893c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT fk_rails_9e8368893c FOREIGN KEY (venda_id) REFERENCES public.vendas(id);


--
-- Name: cupons_fiscais fk_rails_9f40241bf1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cupons_fiscais
    ADD CONSTRAINT fk_rails_9f40241bf1 FOREIGN KEY (venda_id) REFERENCES public.vendas(id);


--
-- Name: tanques fk_rails_9f7f2c3741; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tanques
    ADD CONSTRAINT fk_rails_9f7f2c3741 FOREIGN KEY (combustivel_id) REFERENCES public.combustiveis(id);


--
-- Name: pagamentos fk_rails_a5ea7a63a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pagamentos
    ADD CONSTRAINT fk_rails_a5ea7a63a6 FOREIGN KEY (venda_id) REFERENCES public.vendas(id);


--
-- Name: pagamentos fk_rails_a8f2418b20; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pagamentos
    ADD CONSTRAINT fk_rails_a8f2418b20 FOREIGN KEY (forma_pagamento_id) REFERENCES public.formas_pagamento(id);


--
-- Name: venda_itens fk_rails_b06638c048; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT fk_rails_b06638c048 FOREIGN KEY (produto_id) REFERENCES public.produtos(id);


--
-- Name: pagamentos fk_rails_b463076923; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pagamentos
    ADD CONSTRAINT fk_rails_b463076923 FOREIGN KEY (caixa_id) REFERENCES public.caixas(id);


--
-- Name: historico_precos fk_rails_b4bc2975be; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historico_precos
    ADD CONSTRAINT fk_rails_b4bc2975be FOREIGN KEY (combustivel_id) REFERENCES public.combustiveis(id);


--
-- Name: vendas fk_rails_bad5fec6e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_rails_bad5fec6e4 FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: manutencoes fk_rails_baf1e4ff88; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manutencoes
    ADD CONSTRAINT fk_rails_baf1e4ff88 FOREIGN KEY (tanque_id) REFERENCES public.tanques(id);


--
-- Name: manutencoes fk_rails_c393a32983; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manutencoes
    ADD CONSTRAINT fk_rails_c393a32983 FOREIGN KEY (bico_id) REFERENCES public.bicos(id);


--
-- Name: nota_fiscal_itens fk_rails_c47ddf94a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nota_fiscal_itens
    ADD CONSTRAINT fk_rails_c47ddf94a2 FOREIGN KEY (nota_fiscal_id) REFERENCES public.notas_fiscais(id);


--
-- Name: funcionarios fk_rails_c52a5a3a83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT fk_rails_c52a5a3a83 FOREIGN KEY (cargo_id) REFERENCES public.cargos(id);


--
-- Name: oleos fk_rails_c763e930aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oleos
    ADD CONSTRAINT fk_rails_c763e930aa FOREIGN KEY (produto_id) REFERENCES public.produtos(id);


--
-- Name: fornecedores fk_rails_c8d33978fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fk_rails_c8d33978fd FOREIGN KEY (endereco_id) REFERENCES public.enderecos(id);


--
-- Name: manutencoes fk_rails_ca18176e65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manutencoes
    ADD CONSTRAINT fk_rails_ca18176e65 FOREIGN KEY (bomba_id) REFERENCES public.bombas(id);


--
-- Name: escalas fk_rails_ca2e370243; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.escalas
    ADD CONSTRAINT fk_rails_ca2e370243 FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: movimentacao_estoques fk_rails_d2be42a4a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_estoques
    ADD CONSTRAINT fk_rails_d2be42a4a2 FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: produtos fk_rails_dc32f10a74; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT fk_rails_dc32f10a74 FOREIGN KEY (categoria_id) REFERENCES public.categorias(id);


--
-- Name: caixas fk_rails_dd153b03d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.caixas
    ADD CONSTRAINT fk_rails_dd153b03d1 FOREIGN KEY (escala_id) REFERENCES public.escalas(id);


--
-- Name: clientes fk_rails_dd8c0b6cbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT fk_rails_dd8c0b6cbd FOREIGN KEY (endereco_id) REFERENCES public.enderecos(id);


--
-- Name: leituras_encerrantes fk_rails_ddc0af97e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leituras_encerrantes
    ADD CONSTRAINT fk_rails_ddc0af97e3 FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: cliente_pessoas_juridicas fk_rails_e94a62c87f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cliente_pessoas_juridicas
    ADD CONSTRAINT fk_rails_e94a62c87f FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: bicos fk_rails_edb072825f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bicos
    ADD CONSTRAINT fk_rails_edb072825f FOREIGN KEY (tanque_id) REFERENCES public.tanques(id);


--
-- Name: movimentacao_estoques fk_rails_f16a37a8c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.movimentacao_estoques
    ADD CONSTRAINT fk_rails_f16a37a8c3 FOREIGN KEY (produto_id) REFERENCES public.produtos(id);


--
-- Name: auditoria_eventos fk_rails_f54ed71c1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auditoria_eventos
    ADD CONSTRAINT fk_rails_f54ed71c1c FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: cargo_permissoes fk_rails_f5c0649cd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cargo_permissoes
    ADD CONSTRAINT fk_rails_f5c0649cd1 FOREIGN KEY (cargo_id) REFERENCES public.cargos(id);


--
-- Name: notas_fiscais fk_rails_f9c6378405; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notas_fiscais
    ADD CONSTRAINT fk_rails_f9c6378405 FOREIGN KEY (fornecedor_id) REFERENCES public.fornecedores(id);


--
-- Name: funcionarios fk_rails_fa42dcf7d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT fk_rails_fa42dcf7d1 FOREIGN KEY (endereco_id) REFERENCES public.enderecos(id);


--
-- Name: venda_itens fk_rails_fb114294ad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT fk_rails_fb114294ad FOREIGN KEY (combustivel_id) REFERENCES public.combustiveis(id);


--
-- Name: calibracoes_bicos fk_rails_fb50aadc6b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calibracoes_bicos
    ADD CONSTRAINT fk_rails_fb50aadc6b FOREIGN KEY (bico_id) REFERENCES public.bicos(id);


--
-- Name: fechamento_caixas fk_rails_fc5f91f055; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fechamento_caixas
    ADD CONSTRAINT fk_rails_fc5f91f055 FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- PostgreSQL database dump complete
--

\unrestrict kAEEoaTFyJzrnuKs2LVEUucR9lOrpImTjcPPqDwKMaH8B3myMFhWphfxNial0T8
