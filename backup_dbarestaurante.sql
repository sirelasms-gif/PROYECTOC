--
-- PostgreSQL database dump
--

\restrict uNv6evsU9mcAWcTdxXuiSbGoJde0sWnbvHA3yQB9YSkfuPVc51VVFD5cL0qpBLb

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'WIN1252';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: spaActualizarAdministrador(uuid, uuid, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarAdministrador"(a_idadministrador uuid, a_idsede uuid, a_nombreadministrador character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."Administrador"
    SET "IdSede" = a_idsede, "NombreAdministrador" = a_nombreadministrador
	WHERE "IdAdministrador" = a_idadministrador;
END;
$$;


ALTER FUNCTION public."spaActualizarAdministrador"(a_idadministrador uuid, a_idsede uuid, a_nombreadministrador character varying) OWNER TO postgres;

--
-- Name: spaActualizarAdministrados(uuid, uuid, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarAdministrados"(a_idadministrador uuid, a_idsede uuid, a_nombreadministrador character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."Administrador"
    SET "IdSede" = a_idsede, "NombreAdministrador" = a_nombreadministrador
	WHERE "IdAdministrador" = a_idadministrador;
END;
$$;


ALTER FUNCTION public."spaActualizarAdministrados"(a_idadministrador uuid, a_idsede uuid, a_nombreadministrador character varying) OWNER TO postgres;

--
-- Name: spaActualizarCiudad(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarCiudad"(c_iddepartamento integer, d_idciudad integer, c_nombreciudad character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."Ciudad"
    SET "IdDepartamento" = d_iddepartamento, "NombreCiudad" = c_nombreciudad
	WHERE "IdCiudad" = c_idciudad;
END;
$$;


ALTER FUNCTION public."spaActualizarCiudad"(c_iddepartamento integer, d_idciudad integer, c_nombreciudad character varying) OWNER TO postgres;

--
-- Name: spaActualizarCocina(uuid, uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarCocina"(c_idcocina uuid, c_idsede uuid, c_turnococina character varying, c_horario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."Cocina"
	SET "IdSede" = c_idsede, "TurnoCocina" = c_turnococina, "Horario" = c_horario
    where "IdCocina" = c_IdCocina;
END;
$$;


ALTER FUNCTION public."spaActualizarCocina"(c_idcocina uuid, c_idsede uuid, c_turnococina character varying, c_horario character varying) OWNER TO postgres;

--
-- Name: spaActualizarContabilidad(uuid, date, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarContabilidad"(p_idcontabilidad uuid, p_fecha date, p_total_ventas numeric, p_total_gastos numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_calculado DECIMAL(10,2);
    filas_afectadas INTEGER;
BEGIN
    -- Validaciones
    IF p_total_ventas < 0 THEN
        RETURN 'Las ventas no pueden ser negativas';
    END IF;
    
    IF p_total_gastos < 0 THEN
        RETURN 'Los gastos no pueden ser negativas';
    END IF;
    
    -- Calcular total
    total_calculado := p_total_ventas - p_total_gastos;
    
    -- Actualizar
    UPDATE public."Contabilidad"
    SET 
        "Fecha" = p_fecha,
        "TotalVentas" = p_total_ventas,
        "TotalGastos" = p_total_gastos,
        "Total" = total_calculado
    WHERE "IdContabilidad" = p_idcontabilidad;
    
    GET DIAGNOSTICS filas_afectadas = ROW_COUNT;
    
    IF filas_afectadas = 0 THEN
        RETURN 'No se encontró el registro contable especificado';
    ELSE
        RETURN 'Registro contable actualizado correctamente';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error al actualizar registro contable: ' || SQLERRM;
END;
$$;


ALTER FUNCTION public."spaActualizarContabilidad"(p_idcontabilidad uuid, p_fecha date, p_total_ventas numeric, p_total_gastos numeric) OWNER TO postgres;

--
-- Name: spaActualizarDepartamento(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarDepartamento"(c_iddepartamento integer, d_idpais integer, c_nombredepartamento character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."Departamento"
    SET "IdPais" = d_idpais, "NombreDepartamento" = c_nombredepartamento
	WHERE "IdDepartamento" = c_iddepartamento;
END;
$$;


ALTER FUNCTION public."spaActualizarDepartamento"(c_iddepartamento integer, d_idpais integer, c_nombredepartamento character varying) OWNER TO postgres;

--
-- Name: spaActualizarMesa(uuid, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarMesa"(a_idsede uuid, m_nummesa_actual integer, m_nummesa_nuevo integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    filas_afectadas INTEGER;
BEGIN
    UPDATE public."Mesa"
    SET 
        "NumMesa" = m_nummesa_nuevo
    WHERE "IdSede" = a_idsede AND "NumMesa" = m_nummesa_actual;
    
    GET DIAGNOSTICS filas_afectadas = ROW_COUNT;
    
    IF filas_afectadas = 0 THEN
        RETURN 'No se encontró la mesa especificada';
    ELSE
        RETURN 'Mesa actualizada correctamente';
    END IF;
END;
$$;


ALTER FUNCTION public."spaActualizarMesa"(a_idsede uuid, m_nummesa_actual integer, m_nummesa_nuevo integer) OWNER TO postgres;

--
-- Name: spaActualizarMesero(uuid, uuid, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarMesero"(p_idmesero uuid, p_idsede uuid, p_nombremesero character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."Mesero"
    SET 
        "NombreMesero" = COALESCE(NULLIF(p_nombremesero, ''), "NombreMesero"),
        "IdSede" = COALESCE(p_idsede, "IdSede")
    WHERE "IdMesero" = p_idmesero;
END;
$$;


ALTER FUNCTION public."spaActualizarMesero"(p_idmesero uuid, p_idsede uuid, p_nombremesero character varying) OWNER TO postgres;

--
-- Name: spaActualizarPais(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarPais"(a_idpais integer, a_nombrepais character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."Pais"
    SET "NombreAdministrador" = a_nombrepais
	WHERE "IdPais" = a_idpais;
END;
$$;


ALTER FUNCTION public."spaActualizarPais"(a_idpais integer, a_nombrepais character varying) OWNER TO postgres;

--
-- Name: spaActualizarSede(uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaActualizarSede"(a_idsede uuid, a_nombresede character varying, a_direccion character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    UPDATE public."Sede"
    SET "NombreSede" = a_nombresede, "Direccion" = a_direccion
	WHERE "IdSede" = a_idsede;
END;
$$;


ALTER FUNCTION public."spaActualizarSede"(a_idsede uuid, a_nombresede character varying, a_direccion character varying) OWNER TO postgres;

--
-- Name: spaCerrarDiaContable(uuid, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaCerrarDiaContable"(p_idsede uuid, p_total_gastos numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_ventas DECIMAL(10,2);
    contabilidad_id UUID;
BEGIN
    -- Validaciones
    IF p_total_gastos < 0 THEN
        RETURN 'Los gastos no pueden ser negativos';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM public."Sede" WHERE "IdSede" = p_idsede) THEN
        RETURN 'La sede especificada no existe';
    END IF;
    
    -- Calcular ventas para la sede
    SELECT COALESCE(SUM("Precio"), 0) INTO total_ventas
    FROM public."Comanda"
    WHERE "IdSede" = p_idsede;
    
    IF total_ventas = 0 THEN
        RETURN 'No hay ventas para procesar en esta sede';
    END IF;
    
    -- Generar ID y insertar en contabilidad
    contabilidad_id := gen_random_uuid();
    
    INSERT INTO public."Contabilidad" (
        "IdContabilidad",
        "Fecha",
        "IdSede", 
        "TotalVentas",
        "TotalGastos",
        "Total"
    ) VALUES (
        contabilidad_id,
        CURRENT_DATE,
        p_idsede,
        total_ventas,
        p_total_gastos,
        total_ventas - p_total_gastos
    );
    
    -- Eliminar comandas de esta sede
    DELETE FROM public."Comanda" WHERE "IdSede" = p_idsede;
    
    RETURN 'Dia contable cerrado. Ventas: ' || total_ventas || ', Gastos: ' || p_total_gastos || ', Total: ' || (total_ventas - p_total_gastos);
    
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error al cerrar dia contable: ' || SQLERRM;
END;
$$;


ALTER FUNCTION public."spaCerrarDiaContable"(p_idsede uuid, p_total_gastos numeric) OWNER TO postgres;

--
-- Name: spaConsultarAdministrador(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarAdministrador"(a_idsede uuid) RETURNS TABLE(idadministrador uuid, idsede uuid, nombreadministrador character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdAdministrador" AS idadministrador,
			"IdSede" AS idsede,
			"NombreAdministrador" AS nombreadministrador
	FROM public."Administrador"
	WHERE "IdSede" = a_idsede;

END;
$$;


ALTER FUNCTION public."spaConsultarAdministrador"(a_idsede uuid) OWNER TO postgres;

--
-- Name: spaConsultarCiudad(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarCiudad"(a_iddepartamento integer) RETURNS TABLE(iddepartamento integer, idciudad integer, nombreciudad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdCiudad" AS idciudad,
			"IdDepartamento" AS iddepartamento,
			"NombreCiudad" AS nombreciudad
	FROM public."Ciudad"
	WHERE "IdDepartamento" = a_iddepartamento;

END;
$$;


ALTER FUNCTION public."spaConsultarCiudad"(a_iddepartamento integer) OWNER TO postgres;

--
-- Name: spaConsultarCiudadid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarCiudadid"(a_idciudad integer) RETURNS TABLE(iddepartamento integer, idciudad integer, nombreciudad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdCiudad" AS idciudad,
			"IdDepartamento" AS iddepartamento,
			"NombreCiudad" AS nombreciudad
	FROM public."Ciudad"
	WHERE "IdCiudad" = a_idciudad;

END;
$$;


ALTER FUNCTION public."spaConsultarCiudadid"(a_idciudad integer) OWNER TO postgres;

--
-- Name: spaConsultarComanda(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarComanda"(a_idsede uuid) RETURNS TABLE(idcomanda integer, idmesero uuid, idsede uuid, pedido character varying, descripcion character varying, estado character varying, precio numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        "id_Comanda" AS idcomanda,
        "id_Mesero" AS idmesero,
        "id_Sede" AS idsede,
        "Pedido" AS pedido,
        "Descripcion" AS descripcion,
        "Estado" AS estado,
        "Precio" AS precio
    FROM public."Comanda"
    WHERE "id_Sede" = a_idsede;
END;
$$;


ALTER FUNCTION public."spaConsultarComanda"(a_idsede uuid) OWNER TO postgres;

--
-- Name: spaConsultarComandaid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarComandaid"(a_idcomanda integer) RETURNS TABLE(idcomanda integer, idsede uuid, idmesero uuid, pedido character varying, descripcion character varying, estado character varying, precio numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "id_Comanda" AS idcomanda,
            "id_Mesero" as idmesero,
			"id_Sede" AS idsede,
			"Pedido" AS pedido,
            "Descripcion" as descripcion,
            "Estado" as estado,
            "Precio" as precio
	FROM public."Comanda"
	WHERE "id_Comanda" = a_idcomanda;

END;
$$;


ALTER FUNCTION public."spaConsultarComandaid"(a_idcomanda integer) OWNER TO postgres;

--
-- Name: spaConsultarContabilidad(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarContabilidad"() RETURNS TABLE(idcontabilidad uuid, fecha date, idsede uuid, totalventas numeric, totalgastos numeric, total numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c."IdContabilidad",
        c."Fecha",
        c."IdSede",
        c."TotalVentas",
        c."TotalGastos",
        c."Total"
    FROM public."Contabilidad" c
    ORDER BY c."Fecha" DESC, c."IdSede";
END;
$$;


ALTER FUNCTION public."spaConsultarContabilidad"() OWNER TO postgres;

--
-- Name: spaConsultarContabilidadPorFecha(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarContabilidadPorFecha"(p_fecha date) RETURNS TABLE(idcontabilidad uuid, fecha date, idsede uuid, totalventas numeric, totalgastos numeric, total numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c."IdContabilidad",
        c."Fecha",
        c."IdSede",
        c."TotalVentas",
        c."TotalGastos",
        c."Total"
    FROM public."Contabilidad" c
    WHERE c."Fecha" = p_fecha
    ORDER BY c."IdSede";
END;
$$;


ALTER FUNCTION public."spaConsultarContabilidadPorFecha"(p_fecha date) OWNER TO postgres;

--
-- Name: spaConsultarContabilidadPorId(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarContabilidadPorId"(p_idcontabilidad uuid) RETURNS TABLE(idcontabilidad uuid, fecha date, idsede uuid, totalventas numeric, totalgastos numeric, total numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c."IdContabilidad",
        c."Fecha",
        c."IdSede",
        c."TotalVentas",
        c."TotalGastos",
        c."Total"
    FROM public."Contabilidad" c
    WHERE c."IdContabilidad" = p_idcontabilidad;
END;
$$;


ALTER FUNCTION public."spaConsultarContabilidadPorId"(p_idcontabilidad uuid) OWNER TO postgres;

--
-- Name: spaConsultarContabilidadPorSede(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarContabilidadPorSede"(p_idsede uuid) RETURNS TABLE(idcontabilidad uuid, fecha date, idsede uuid, totalventas numeric, totalgastos numeric, total numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c."IdContabilidad",
        c."Fecha",
        c."IdSede",
        c."TotalVentas",
        c."TotalGastos",
        c."Total"
    FROM public."Contabilidad" c
    WHERE c."IdSede" = p_idsede
    ORDER BY c."Fecha" DESC;
END;
$$;


ALTER FUNCTION public."spaConsultarContabilidadPorSede"(p_idsede uuid) OWNER TO postgres;

--
-- Name: spaConsultarDepartamento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarDepartamento"(d_idpais integer) RETURNS TABLE(idpais integer, iddepartamento integer, nombredepartamento character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdDepartamento" AS iddepartamento,
			"IdPais" AS idpais,
			"NombreDepartamento" AS nombredepartamento
	FROM public."Departamento"
    WHERE "IdPais" = d_idpais;
END;
$$;


ALTER FUNCTION public."spaConsultarDepartamento"(d_idpais integer) OWNER TO postgres;

--
-- Name: spaConsultarDepartamentoid(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarDepartamentoid"(d_iddepartamento integer) RETURNS TABLE(idpais integer, iddepartamento integer, nombredepartamento character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdDepartamento" AS iddepartamento,
			"IdPais" AS idpais,
			"NombreDepartamento" AS nombredepartamento
	FROM public."Departamento"
    WHERE "IdDepartamento" = d_iddepartamento;
END;
$$;


ALTER FUNCTION public."spaConsultarDepartamentoid"(d_iddepartamento integer) OWNER TO postgres;

--
-- Name: spaConsultarIdAdministrador(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarIdAdministrador"(a_idadministrador uuid) RETURNS TABLE(idadministrador uuid, idsede uuid, nombreadministrador character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdAdministrador" AS idadministrador,
			"IdSede" AS idsede,
			"NombreAdministrador" AS nombreadministrador
	FROM public."Administrador"
	WHERE "IdAdministrador" = a_idadministrador;

END;
$$;


ALTER FUNCTION public."spaConsultarIdAdministrador"(a_idadministrador uuid) OWNER TO postgres;

--
-- Name: spaConsultarIdCocina(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarIdCocina"(c_idcocina uuid) RETURNS TABLE(idcocina uuid, idsede uuid, turnococina character varying, horario character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdCocina" AS idcocina,
			"IdSede" AS idsede,
			"TurnoCocina" AS turnococina,
            "Horario" as horario
	FROM public."Cocina"
	WHERE "IdCocina" = c_idcocina;

END;
$$;


ALTER FUNCTION public."spaConsultarIdCocina"(c_idcocina uuid) OWNER TO postgres;

--
-- Name: spaConsultarIdturno(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarIdturno"(c_idturno uuid) RETURNS TABLE(idcocina uuid, idsede uuid, turnococina character varying, horario character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdCocina" AS idcocina,
			"IdSede" AS idsede,
			"TurnoCocina" AS turnococina,
            "Horario"
	FROM public."Cocina"
	WHERE "IdCocina" = c_idturno;

END;
$$;


ALTER FUNCTION public."spaConsultarIdturno"(c_idturno uuid) OWNER TO postgres;

--
-- Name: spaConsultarMesas(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarMesas"(a_idsede uuid) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_mesas bigint;
BEGIN
    SELECT COUNT(*) INTO total_mesas
    FROM public."Mesa"
    WHERE "IdSede" = a_idsede;
    
    RETURN total_mesas;
END;
$$;


ALTER FUNCTION public."spaConsultarMesas"(a_idsede uuid) OWNER TO postgres;

--
-- Name: spaConsultarMesero(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarMesero"(p_idsede uuid) RETURNS TABLE("IdMesero" uuid, "IdSede" uuid, "NombreMesero" character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT m."IdMesero", m."IdSede", m."NombreMesero"
    FROM public."Mesero" as m
    WHERE m."IdSede" = p_IdSede;
END;
$$;


ALTER FUNCTION public."spaConsultarMesero"(p_idsede uuid) OWNER TO postgres;

--
-- Name: spaConsultarMeseroId(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarMeseroId"(a_meseroid uuid) RETURNS TABLE(idmesero uuid, idsede uuid, nombremesero character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT
    "IdMesero",
    "IdSede",
    "NombreMesero"
    FROM public."Mesero"
    WHERE "IdMesero" = a_meseroid;
    
END;
$$;


ALTER FUNCTION public."spaConsultarMeseroId"(a_meseroid uuid) OWNER TO postgres;

--
-- Name: spaConsultarPais(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarPais"(p_idpais integer) RETURNS TABLE(idpais integer, nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdPais" AS IdPais,
			"NombrePais" AS Nombre
	FROM public."Pais"
	WHERE "IdPais" = p_idpais;

END;
$$;


ALTER FUNCTION public."spaConsultarPais"(p_idpais integer) OWNER TO postgres;

--
-- Name: spaConsultarSede(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarSede"(a_idsede uuid) RETURNS TABLE(direccion character varying, idsede uuid, nombresede character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "Direccion" AS direccion,
			"IdSede" AS idsede,
			"NombreSede" AS nombresede
	FROM public."Sede"
	WHERE "IdSede" = a_idsede;

END;
$$;


ALTER FUNCTION public."spaConsultarSede"(a_idsede uuid) OWNER TO postgres;

--
-- Name: spaConsultarTodasMesas(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodasMesas"() RETURNS TABLE(id_sede uuid, cantidad_mesas bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        "IdSede" as id_sede,
        COUNT(*) as cantidad_mesas
    FROM public."Mesa"
    GROUP BY "IdSede"
    ORDER BY cantidad_mesas DESC;
END;
$$;


ALTER FUNCTION public."spaConsultarTodasMesas"() OWNER TO postgres;

--
-- Name: spaConsultarTodoAdministrador(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodoAdministrador"() RETURNS TABLE(idadministrador uuid, idsede uuid, nombreadministrador character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdAdministrador" AS idadministrador,
			"IdSede" AS idsede,
			"NombreAdministrador" AS nombreadministrador
	FROM public."Administrador";
END;
$$;


ALTER FUNCTION public."spaConsultarTodoAdministrador"() OWNER TO postgres;

--
-- Name: spaConsultarTodoCiudad(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodoCiudad"() RETURNS TABLE(iddepartamento integer, idciudad integer, nombreciudad character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdCiudad" AS idciudad,
			"IdDepartamento" AS iddepartamento,
			"NombreCiudad" AS nombreciudad
	FROM public."Ciudad";

END;
$$;


ALTER FUNCTION public."spaConsultarTodoCiudad"() OWNER TO postgres;

--
-- Name: spaConsultarTodoCocina(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodoCocina"() RETURNS TABLE(idcocina uuid, idsede uuid, turnococina character varying, horario character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdCocina" AS idcocina,
			"IdSede" AS idsede,
			"TurnoCocina" AS turnococina,
            "Horario" as horario
	FROM public."Cocina";

END;
$$;


ALTER FUNCTION public."spaConsultarTodoCocina"() OWNER TO postgres;

--
-- Name: spaConsultarTodoDepartamento(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodoDepartamento"() RETURNS TABLE(idpais integer, iddepartamento integer, nombredepartamento character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdDepartamento" AS iddepartamento,
			"IdPais" AS idpais,
			"NombreDepartamento" AS nombredepartamento
	FROM public."Departamento";
END;
$$;


ALTER FUNCTION public."spaConsultarTodoDepartamento"() OWNER TO postgres;

--
-- Name: spaConsultarTodoMesero(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodoMesero"() RETURNS TABLE(idmesero uuid, idsede uuid, nombremesero character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY 
    SELECT
    "IdMesero",
    "IdSede",
    "NombreMesero"
    FROM public."Mesero";
    
END;
$$;


ALTER FUNCTION public."spaConsultarTodoMesero"() OWNER TO postgres;

--
-- Name: spaConsultarTodoPais(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodoPais"() RETURNS TABLE(idpais integer, nombre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdPais" AS IdPais,
			"NombrePais" AS Nombre
	FROM public."Pais";

END;
$$;


ALTER FUNCTION public."spaConsultarTodoPais"() OWNER TO postgres;

--
-- Name: spaConsultarTodoSede(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTodoSede"() RETURNS TABLE(direccion character varying, idsede uuid, nombresede character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "Direccion" AS direccion,
			"IdSede" AS idsede,
			"NombreSede" AS nombresede
	FROM public."Sede";

END;
$$;


ALTER FUNCTION public."spaConsultarTodoSede"() OWNER TO postgres;

--
-- Name: spaConsultarTurno(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaConsultarTurno"(a_idsede uuid) RETURNS TABLE(idcocina uuid, idsede uuid, turnococina character varying, horario character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY
 
	SELECT "IdCocina" AS idcocina,
			"IdSede" AS idsede,
			"TurnoCocina" AS turnococina,
            "Horario" as horario
	FROM public."Cocina"
	WHERE "IdSede" = a_idsede;

END;
$$;


ALTER FUNCTION public."spaConsultarTurno"(a_idsede uuid) OWNER TO postgres;

--
-- Name: spaCrearContabilidad(uuid, numeric, numeric, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaCrearContabilidad"(p_idsede uuid, p_total_ventas numeric, p_total_gastos numeric, p_fecha date DEFAULT CURRENT_DATE) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    nuevo_id UUID;
    total_calculado DECIMAL(10,2);
BEGIN
    -- Validaciones
    IF p_total_ventas < 0 THEN
        RETURN 'Las ventas no pueden ser negativas';
    END IF;
    
    IF p_total_gastos < 0 THEN
        RETURN 'Los gastos no pueden ser negativas';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM public."Sede" WHERE "IdSede" = p_idsede) THEN
        RETURN 'La sede especificada no existe';
    END IF;
    
    -- Calcular total
    total_calculado := p_total_ventas - p_total_gastos;
    
    -- Insertar
    nuevo_id := gen_random_uuid();
    
    INSERT INTO public."Contabilidad" (
        "IdContabilidad",
        "Fecha",
        "IdSede", 
        "TotalVentas",
        "TotalGastos",
        "Total"
    ) VALUES (
        nuevo_id,
        p_fecha,
        p_idsede,
        p_total_ventas,
        p_total_gastos,
        total_calculado
    );
    
    RETURN 'Registro contable creado. ID: ' || nuevo_id;
    
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error al crear registro contable: ' || SQLERRM;
END;
$$;


ALTER FUNCTION public."spaCrearContabilidad"(p_idsede uuid, p_total_ventas numeric, p_total_gastos numeric, p_fecha date) OWNER TO postgres;

--
-- Name: spaEditarComanda(integer, uuid, character varying, character varying, character varying, numeric, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEditarComanda"(a_idcomanda integer, a_idmesero uuid, a_pedido character varying, a_descripcion character varying, a_estado character varying, a_precio numeric, a_idsede uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE public."Comanda"
    SET 
        "id_Mesero" = a_idmesero, 
        "Pedido" = a_pedido, 
        "Descripcion" = a_descripcion, 
        "Estado" = a_estado, 
        "Precio" = a_precio,
        "id_Sede" = a_idsede
    WHERE "id_Comanda" = a_idcomanda;
END;
$$;


ALTER FUNCTION public."spaEditarComanda"(a_idcomanda integer, a_idmesero uuid, a_pedido character varying, a_descripcion character varying, a_estado character varying, a_precio numeric, a_idsede uuid) OWNER TO postgres;

--
-- Name: spaEditarComanda(uuid, uuid, character varying, character varying, character varying, numeric, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEditarComanda"(idcomanda uuid, idmesero uuid, p_pedido character varying, descripcion character varying, estado character varying, precio numeric, idsede uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."Comanda"
    SET "id_Mesero" = idmesero, "Pedido" = p_pedido, "Descripcion" =  descripcion, "Estado" = estado,  "Precio" = precio,
    "id_Sede" =idsede
    WHERE "id_Comanda" = idcomanda;
END;
$$;


ALTER FUNCTION public."spaEditarComanda"(idcomanda uuid, idmesero uuid, p_pedido character varying, descripcion character varying, estado character varying, precio numeric, idsede uuid) OWNER TO postgres;

--
-- Name: spaEliminaPais(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminaPais"(p_paisid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE 
	FROM public."Pais"
	WHERE "IdPais" = p_paisid;
END;
$$;


ALTER FUNCTION public."spaEliminaPais"(p_paisid integer) OWNER TO postgres;

--
-- Name: spaEliminarAdministrador(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarAdministrador"(a_idadministrador uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

    DELETE
	FROM public."Administrador"
	WHERE "IdAdministrador" = a_idadministrador;

END;
$$;


ALTER FUNCTION public."spaEliminarAdministrador"(a_idadministrador uuid) OWNER TO postgres;

--
-- Name: spaEliminarCiudad(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarCiudad"(c_idciudad integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE 
	FROM public."Ciudad"
	WHERE "IdCiudad" = c_IdCiudad;
END;
$$;


ALTER FUNCTION public."spaEliminarCiudad"(c_idciudad integer) OWNER TO postgres;

--
-- Name: spaEliminarComanda(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarComanda"(c_idcomanda integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    es_ultima_comanda BOOLEAN;
    max_id_actual INTEGER;
BEGIN
    -- Verificar si la comanda existe
    IF NOT EXISTS (SELECT 1 FROM public."Comanda" WHERE "id_Comanda" = c_IdComanda) THEN
        RETURN 'No se encontro la comanda especificada';
    END IF;
    
    -- Verificar si es la ultima comanda (la de ID mas alto)
    SELECT NOT EXISTS (
        SELECT 1 FROM public."Comanda" 
        WHERE "id_Comanda" > c_IdComanda
    ) INTO es_ultima_comanda;
    
    -- Eliminar la comanda
    DELETE FROM public."Comanda"
    WHERE "id_Comanda" = c_IdComanda;
    
    -- Si era la ultima comanda, reiniciar la secuencia
    IF es_ultima_comanda THEN
        -- Obtener el nuevo maximo ID
        SELECT COALESCE(MAX("id_Comanda"), 0) INTO max_id_actual
        FROM public."Comanda";
        
        -- Si no hay comandas, reiniciar a 1, no a 0
        IF max_id_actual = 0 THEN
            PERFORM setval(
                pg_get_serial_sequence('public."Comanda"', 'id_Comanda'),
                1, 
                false
            );
            RETURN format('Comanda %s eliminada. Secuencia reiniciada a 1', c_IdComanda);
        ELSE
            -- Reiniciar la secuencia al maximo actual
            PERFORM setval(
                pg_get_serial_sequence('public."Comanda"', 'id_Comanda'),
                max_id_actual, 
                false
            );
            RETURN format('Comanda %s eliminada. Secuencia reiniciada desde %s', 
                         c_IdComanda, max_id_actual);
        END IF;
    ELSE
        RETURN format('Comanda %s eliminada. Secuencia mantenida', c_IdComanda);
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error: ' || SQLERRM;
END;
$$;


ALTER FUNCTION public."spaEliminarComanda"(c_idcomanda integer) OWNER TO postgres;

--
-- Name: spaEliminarContabilidad(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarContabilidad"(p_idcontabilidad uuid) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    filas_afectadas INTEGER;
BEGIN
    DELETE FROM public."Contabilidad"
    WHERE "IdContabilidad" = p_idcontabilidad;
    
    GET DIAGNOSTICS filas_afectadas = ROW_COUNT;
    
    IF filas_afectadas = 0 THEN
        RETURN 'No se encontró el registro contable especificado';
    ELSE
        RETURN 'Registro contable eliminado correctamente';
    END IF;
    
EXCEPTION WHEN OTHERS THEN
    RETURN 'Error al eliminar registro contable: ' || SQLERRM;
END;
$$;


ALTER FUNCTION public."spaEliminarContabilidad"(p_idcontabilidad uuid) OWNER TO postgres;

--
-- Name: spaEliminarDepartamento(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarDepartamento"(d_iddepartamento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE 
	FROM public."Departamento"
	WHERE "IdDepartamento" = d_iddepartamento;
END;
$$;


ALTER FUNCTION public."spaEliminarDepartamento"(d_iddepartamento integer) OWNER TO postgres;

--
-- Name: spaEliminarMesa(uuid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarMesa"(c_idsede uuid, m_nummesa integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE 
	FROM public."Mesa"
	WHERE "IdSede" = c_IdSede AND "NumMesa" = m_nummesa;
END;
$$;


ALTER FUNCTION public."spaEliminarMesa"(c_idsede uuid, m_nummesa integer) OWNER TO postgres;

--
-- Name: spaEliminarMesero(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarMesero"(p_idmesero uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE 
	FROM public."Mesero"
	WHERE "IdMesero" = p_idmesero;
END;
$$;


ALTER FUNCTION public."spaEliminarMesero"(p_idmesero uuid) OWNER TO postgres;

--
-- Name: spaEliminarSede(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarSede"(c_idsede uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE 
	FROM public."Sede"
	WHERE "IdSede" = c_IdSede;
END;
$$;


ALTER FUNCTION public."spaEliminarSede"(c_idsede uuid) OWNER TO postgres;

--
-- Name: spaEliminarTurno(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaEliminarTurno"(c_idcocina uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE 
	FROM public."Cocina"
	WHERE "IdCocina" = c_IdCocina;
END;
$$;


ALTER FUNCTION public."spaEliminarTurno"(c_idcocina uuid) OWNER TO postgres;

--
-- Name: spaIngresaCiudad(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaIngresaCiudad"(p_nombreciudad character varying, c_iddepartamento integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO "Ciudad"("IdDepartamento","NombreCiudad")
	VALUES(c_iddepartamento,p_nombreciudad);
END;
$$;


ALTER FUNCTION public."spaIngresaCiudad"(p_nombreciudad character varying, c_iddepartamento integer) OWNER TO postgres;

--
-- Name: spaIngresaComanda(uuid, character varying, character varying, character varying, numeric, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaIngresaComanda"(idmesero uuid, p_pedido character varying, descripcion character varying, estado character varying, precio numeric, idsede uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO "Comanda"("id_Mesero", "Pedido", "Descripcion", "Estado", "Precio", "id_Sede")
	VALUES(idmesero, p_pedido, descripcion, estado, precio, idsede);
END;
$$;


ALTER FUNCTION public."spaIngresaComanda"(idmesero uuid, p_pedido character varying, descripcion character varying, estado character varying, precio numeric, idsede uuid) OWNER TO postgres;

--
-- Name: spaIngresaDepartamento(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaIngresaDepartamento"(d_idpais integer, p_nombredepartamento character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO "Departamento"("IdPais","NombreDepartamento")
	VALUES(d_idpais ,p_nombredepartamento);
END;
$$;


ALTER FUNCTION public."spaIngresaDepartamento"(d_idpais integer, p_nombredepartamento character varying) OWNER TO postgres;

--
-- Name: spaIngresaPais(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaIngresaPais"(p_nombre character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO "Pais"("NombrePais")
	VALUES(P_Nombre);
END;
$$;


ALTER FUNCTION public."spaIngresaPais"(p_nombre character varying) OWNER TO postgres;

--
-- Name: spaIngresarAdministrador(uuid, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaIngresarAdministrador"(p_idsede uuid, p_nombreadministrador character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT into "Administrador" ("IdSede", "NombreAdministrador")
    VALUES (p_idsede, p_nombreadministrador);
END;
$$;


ALTER FUNCTION public."spaIngresarAdministrador"(p_idsede uuid, p_nombreadministrador character varying) OWNER TO postgres;

--
-- Name: spaIngresarMesero(uuid, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaIngresarMesero"(p_idsede uuid, p_nombremesero character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT into "Mesero" ("IdSede", "NombreMesero")
    VALUES (p_idsede, p_nombremesero);
END;
$$;


ALTER FUNCTION public."spaIngresarMesero"(p_idsede uuid, p_nombremesero character varying) OWNER TO postgres;

--
-- Name: spaIngresarTurno(uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."spaIngresarTurno"(c_idsede uuid, c_turnococina character varying, c_horario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "Cocina"("IdSede", "TurnoCocina", "Horario")
    VALUES (c_idsede, c_turnococina, c_horario);

END;
$$;


ALTER FUNCTION public."spaIngresarTurno"(c_idsede uuid, c_turnococina character varying, c_horario character varying) OWNER TO postgres;

--
-- Name: spaingresarmesa(uuid, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.spaingresarmesa(p_idsede uuid, p_nummesa integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT into "Mesa" ("IdSede", "NumMesa")
    VALUES (p_idsede, p_nummesa);
END;
$$;


ALTER FUNCTION public.spaingresarmesa(p_idsede uuid, p_nummesa integer) OWNER TO postgres;

--
-- Name: spaingresarsede(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.spaingresarsede(p_nombrepais character varying, p_direccion character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT into "Sede" ("NombreSede", "Direccion")
    VALUES (p_nombrepais, p_direccion);
END;
$$;


ALTER FUNCTION public.spaingresarsede(p_nombrepais character varying, p_direccion character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Administrador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Administrador" (
    "IdAdministrador" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "IdSede" uuid NOT NULL,
    "NombreAdministrador" character varying(64)
);


ALTER TABLE public."Administrador" OWNER TO postgres;

--
-- Name: Ciudad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ciudad" (
    "IdCiudad" integer NOT NULL,
    "IdDepartamento" integer NOT NULL,
    "NombreCiudad" character varying(100)
);


ALTER TABLE public."Ciudad" OWNER TO postgres;

--
-- Name: Ciudad_IdCiudad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Ciudad_IdCiudad_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Ciudad_IdCiudad_seq" OWNER TO postgres;

--
-- Name: Ciudad_IdCiudad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Ciudad_IdCiudad_seq" OWNED BY public."Ciudad"."IdCiudad";


--
-- Name: Cocina; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Cocina" (
    "IdCocina" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "IdSede" uuid NOT NULL,
    "TurnoCocina" character varying(64),
    "Horario" character varying(64) DEFAULT NULL::character varying
);


ALTER TABLE public."Cocina" OWNER TO postgres;

--
-- Name: Comanda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Comanda" (
    "id_Comanda" integer NOT NULL,
    "id_Mesero" uuid,
    "Pedido" character varying(500) NOT NULL,
    "Descripcion" character varying(10000),
    "Estado" character varying(25),
    "Precio" numeric(10,2),
    "id_Sede" uuid
);


ALTER TABLE public."Comanda" OWNER TO postgres;

--
-- Name: Comanda_id_Comanda_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."Comanda" ALTER COLUMN "id_Comanda" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Comanda_id_Comanda_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Contabilidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Contabilidad" (
    "IdContabilidad" uuid DEFAULT gen_random_uuid() NOT NULL,
    "Fecha" date DEFAULT CURRENT_DATE NOT NULL,
    "IdSede" uuid NOT NULL,
    "TotalVentas" numeric(10,2) DEFAULT 0,
    "TotalGastos" numeric(10,2) DEFAULT 0,
    "Total" numeric(10,2) DEFAULT 0
);


ALTER TABLE public."Contabilidad" OWNER TO postgres;

--
-- Name: Departamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Departamento" (
    "IdDepartamento" integer NOT NULL,
    "IdPais" integer,
    "NombreDepartamento" character varying(100)
);


ALTER TABLE public."Departamento" OWNER TO postgres;

--
-- Name: Departamento_IdDepartamento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Departamento_IdDepartamento_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Departamento_IdDepartamento_seq" OWNER TO postgres;

--
-- Name: Departamento_IdDepartamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Departamento_IdDepartamento_seq" OWNED BY public."Departamento"."IdDepartamento";


--
-- Name: Mesa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Mesa" (
    "NumMesa" integer NOT NULL,
    "IdSede" uuid NOT NULL
);


ALTER TABLE public."Mesa" OWNER TO postgres;

--
-- Name: Mesero; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Mesero" (
    "IdMesero" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "IdSede" uuid NOT NULL,
    "NombreMesero" character varying(64)
);


ALTER TABLE public."Mesero" OWNER TO postgres;

--
-- Name: Pais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Pais" (
    "IdPais" integer NOT NULL,
    "NombrePais" character varying(100)
);


ALTER TABLE public."Pais" OWNER TO postgres;

--
-- Name: Pais_IdPais_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Pais_IdPais_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Pais_IdPais_seq" OWNER TO postgres;

--
-- Name: Pais_IdPais_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Pais_IdPais_seq" OWNED BY public."Pais"."IdPais";


--
-- Name: Sede; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Sede" (
    "IdSede" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "NombreSede" character varying(250) NOT NULL,
    "Direccion" character varying(250) NOT NULL
);


ALTER TABLE public."Sede" OWNER TO postgres;

--
-- Name: Ciudad IdCiudad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ciudad" ALTER COLUMN "IdCiudad" SET DEFAULT nextval('public."Ciudad_IdCiudad_seq"'::regclass);


--
-- Name: Departamento IdDepartamento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Departamento" ALTER COLUMN "IdDepartamento" SET DEFAULT nextval('public."Departamento_IdDepartamento_seq"'::regclass);


--
-- Name: Pais IdPais; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pais" ALTER COLUMN "IdPais" SET DEFAULT nextval('public."Pais_IdPais_seq"'::regclass);


--
-- Data for Name: Administrador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Administrador" ("IdAdministrador", "IdSede", "NombreAdministrador") FROM stdin;
973ef016-ae1a-4e0b-8c5a-1c4b2d103156	d6c83e18-e433-4fb1-9102-dde4a2475a6b	Juan Carlos Ramirez
\.


--
-- Data for Name: Ciudad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Ciudad" ("IdCiudad", "IdDepartamento", "NombreCiudad") FROM stdin;
1	1	Medellin
2	1	asdasfafsasd
\.


--
-- Data for Name: Cocina; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Cocina" ("IdCocina", "IdSede", "TurnoCocina", "Horario") FROM stdin;
0fcb7f25-1450-4a44-bb9b-687dc96796a4	06902d16-96ec-44e3-bb43-e0d96ea84e67	Turno 2	12:00PM - 6:00PM
\.


--
-- Data for Name: Comanda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Comanda" ("id_Comanda", "id_Mesero", "Pedido", "Descripcion", "Estado", "Precio", "id_Sede") FROM stdin;
\.


--
-- Data for Name: Contabilidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Contabilidad" ("IdContabilidad", "Fecha", "IdSede", "TotalVentas", "TotalGastos", "Total") FROM stdin;
\.


--
-- Data for Name: Departamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Departamento" ("IdDepartamento", "IdPais", "NombreDepartamento") FROM stdin;
1	1	Antioquia
2	1	strinasdasdadg
3	2	strinsadasfa asg
\.


--
-- Data for Name: Mesa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Mesa" ("NumMesa", "IdSede") FROM stdin;
1	317a4efa-38c9-47fd-8d87-4a1d0c4a0aa8
2	06902d16-96ec-44e3-bb43-e0d96ea84e67
\.


--
-- Data for Name: Mesero; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Mesero" ("IdMesero", "IdSede", "NombreMesero") FROM stdin;
973e5a06-6f7a-4f55-a903-9884004b5a9e	06902d16-96ec-44e3-bb43-e0d96ea84e67	Juan Carlos Bodoque
ec996884-6d44-414b-aefa-4c9d2d2a9dac	9b060862-5934-4e02-aeee-e8f1e372cdfd	Luis Antonio Posada Mesa
6b230559-b5e2-455b-9a00-2d7bde0f408e	d6c83e18-e433-4fb1-9102-dde4a2475a6b	Juan
0cdf905e-ca17-40a5-9bf2-aad9c72044a9	d6c83e18-e433-4fb1-9102-dde4a2475a6b	Jose Luis
\.


--
-- Data for Name: Pais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Pais" ("IdPais", "NombrePais") FROM stdin;
1	Colombia
2	MÃ©xico
3	Chile
4	EspaÃ±a
\.


--
-- Data for Name: Sede; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Sede" ("IdSede", "NombreSede", "Direccion") FROM stdin;
317a4efa-38c9-47fd-8d87-4a1d0c4a0aa8	Calazans	Calle 56 #25-32 local 15
d6c83e18-e433-4fb1-9102-dde4a2475a6b	Aranjuez	Calle 24 #55-32b
06902d16-96ec-44e3-bb43-e0d96ea84e67	Barrio Obrero	Calle 27c #21-12
9b060862-5934-4e02-aeee-e8f1e372cdfd	Girardota	Calle 36 #22-58b
\.


--
-- Name: Ciudad_IdCiudad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Ciudad_IdCiudad_seq"', 2, true);


--
-- Name: Comanda_id_Comanda_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Comanda_id_Comanda_seq"', 1, false);


--
-- Name: Departamento_IdDepartamento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Departamento_IdDepartamento_seq"', 3, true);


--
-- Name: Pais_IdPais_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pais_IdPais_seq"', 4, true);


--
-- Name: Ciudad Ciudad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ciudad"
    ADD CONSTRAINT "Ciudad_pkey" PRIMARY KEY ("IdCiudad", "IdDepartamento");


--
-- Name: Comanda Comanda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comanda"
    ADD CONSTRAINT "Comanda_pkey" PRIMARY KEY ("id_Comanda");


--
-- Name: Contabilidad Contabilidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Contabilidad"
    ADD CONSTRAINT "Contabilidad_pkey" PRIMARY KEY ("IdContabilidad", "IdSede");


--
-- Name: Departamento Departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Departamento"
    ADD CONSTRAINT "Departamento_pkey" PRIMARY KEY ("IdDepartamento");


--
-- Name: Mesa Mesa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Mesa"
    ADD CONSTRAINT "Mesa_pkey" PRIMARY KEY ("IdSede", "NumMesa");


--
-- Name: Mesero Mesero_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Mesero"
    ADD CONSTRAINT "Mesero_pkey" PRIMARY KEY ("IdMesero");


--
-- Name: Pais Pais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pais"
    ADD CONSTRAINT "Pais_pkey" PRIMARY KEY ("IdPais");


--
-- Name: Sede Sede_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Sede"
    ADD CONSTRAINT "Sede_pkey" PRIMARY KEY ("IdSede");


--
-- Name: idx_contabilidad_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contabilidad_fecha ON public."Contabilidad" USING btree ("Fecha");


--
-- Name: idx_contabilidad_sede; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contabilidad_sede ON public."Contabilidad" USING btree ("IdSede");


--
-- Name: Ciudad Ciudad_IdDepartamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ciudad"
    ADD CONSTRAINT "Ciudad_IdDepartamento_fkey" FOREIGN KEY ("IdDepartamento") REFERENCES public."Departamento"("IdDepartamento") ON DELETE CASCADE;


--
-- Name: Comanda Comanda_id_Mesero_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comanda"
    ADD CONSTRAINT "Comanda_id_Mesero_fkey" FOREIGN KEY ("id_Mesero") REFERENCES public."Mesero"("IdMesero");


--
-- Name: Comanda Comanda_id_Sede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comanda"
    ADD CONSTRAINT "Comanda_id_Sede_fkey" FOREIGN KEY ("id_Sede") REFERENCES public."Sede"("IdSede") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Contabilidad Contabilidad_IdSede_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Contabilidad"
    ADD CONSTRAINT "Contabilidad_IdSede_fkey" FOREIGN KEY ("IdSede") REFERENCES public."Sede"("IdSede");


--
-- Name: Departamento Departamento_IdPais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Departamento"
    ADD CONSTRAINT "Departamento_IdPais_fkey" FOREIGN KEY ("IdPais") REFERENCES public."Pais"("IdPais") ON DELETE CASCADE;


--
-- Name: Administrador FK_Administrador_Sede; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Administrador"
    ADD CONSTRAINT "FK_Administrador_Sede" FOREIGN KEY ("IdSede") REFERENCES public."Sede"("IdSede");


--
-- Name: Cocina FK_Cocina_Sede; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cocina"
    ADD CONSTRAINT "FK_Cocina_Sede" FOREIGN KEY ("IdSede") REFERENCES public."Sede"("IdSede");


--
-- Name: Mesa FK_Mesa_Sede; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Mesa"
    ADD CONSTRAINT "FK_Mesa_Sede" FOREIGN KEY ("IdSede") REFERENCES public."Sede"("IdSede");


--
-- Name: Mesero FK_Mesero_Sede; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Mesero"
    ADD CONSTRAINT "FK_Mesero_Sede" FOREIGN KEY ("IdSede") REFERENCES public."Sede"("IdSede");


--
-- PostgreSQL database dump complete
--

\unrestrict uNv6evsU9mcAWcTdxXuiSbGoJde0sWnbvHA3yQB9YSkfuPVc51VVFD5cL0qpBLb

