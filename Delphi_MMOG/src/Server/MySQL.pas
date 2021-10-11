{*******************************************************}
{                                                       }
{         API интерфейс для libmySQL.dll 5.0            }
{                                                       }
{  Автор перевода C->Pascal: Виталий Лещенко            }
{                            www.vitaliy.org            }
{                                                       }
{*******************************************************}
{ Лицензионное соглашение:                              }
{ Данный программный продукт распространяется бесплатно }
{ по принципу "AS IS", без каких-либо гарантий.         }
{ Вы используете его на свой риск.                      }
{ Вы можете свободно использовать его в своих проектах. }
{*******************************************************}

unit MySQL;

interface

const
  libmySQL                      = 'libmySQL.dll';

  MYSQL_ERRMSG_SIZE             = 512;
  SQLSTATE_LENGTH               = 5;
  MYSQL_PORT                    = 3306;
  LOCAL_HOST                    = 'localhost'; 
  MYSQL_UNIX_ADDR               = '/tmp/mysql.sock'; 
  NAME_LEN                      = 64; 
  PROTOCOL_VERSION              = 10; 
  MYSQL_SERVER_VERSION          = '5.0.21';
  MYSQL_BASE_VERSION            = 'mysqld-5.0';
  MYSQL_SERVER_SUFFIX_DEF       = '-community-max-nt';
  FRM_VER                       = 6;
  MYSQL_VERSION_ID              = 50021;
  field_type_decimal            = 0; 
  field_type_tiny               = 1; 
  field_type_short              = 2;
  field_type_long               = 3; 
  field_type_float              = 4; 
  field_type_double             = 5; 
  field_type_null               = 6; 
  field_type_timestamp          = 7; 
  field_type_longlong           = 8; 
  field_type_int24              = 9; 
  field_type_date               = 10; 
  field_type_time               = 11; 
  field_type_datetime           = 12; 
  field_type_enum               = 247; 
  field_type_set                = 248;
  field_type_tiny_blob          = 249;
  field_type_medium_blob        = 250;
  field_type_long_blob          = 251;
  field_type_blob               = 252;
  field_type_var_string         = 253;
  field_type_string             = 254;

  SCRAMBLE_LENGTH               = 20;
  SCRAMBLE_LENGTH_323           = 8;

type
  my_bool = ByteBool;
  pmy_bool = ^my_bool;

  enum_field_types = byte;
  socket = word;

  my_ulonglong = Int64;

  my_socket = Integer;

  MYSQL_FIELD_OFFSET = LongWord;
  MYSQL_ROW_OFFSET = LongWord;

  gptr = PChar;

  pmy_charset_info = ^character_set;
  character_set = record
    number: LongWord;
    state: LongWord;
    csname: PChar;
    name: PChar;
    comment: PChar;
    dir: PChar;
    mbminlen: LongWord;
    mbmaxlen: LongWord;
  end;
  MY_CHARSET_INFO = character_set;  

  MYSQL_STATUS = (MYSQL_STATUS_READY,MYSQL_STATUS_GET_RESULT,MYSQL_STATUS_USE_RESULT);
  MYSQL_OPTION = (
    MYSQL_OPT_CONNECT_TIMEOUT, MYSQL_OPT_COMPRESS, MYSQL_OPT_NAMED_PIPE,
    MYSQL_INIT_COMMAND, MYSQL_READ_DEFAULT_FILE, MYSQL_READ_DEFAULT_GROUP,
    MYSQL_SET_CHARSET_DIR, MYSQL_SET_CHARSET_NAME, MYSQL_OPT_LOCAL_INFILE,
    MYSQL_OPT_PROTOCOL, MYSQL_SHARED_MEMORY_BASE_NAME, MYSQL_OPT_READ_TIMEOUT,
    MYSQL_OPT_WRITE_TIMEOUT, MYSQL_OPT_USE_RESULT,
    MYSQL_OPT_USE_REMOTE_CONNECTION, MYSQL_OPT_USE_EMBEDDED_CONNECTION,
    MYSQL_OPT_GUESS_CONNECTION, MYSQL_SET_CLIENT_IP, MYSQL_SECURE_AUTH,
    MYSQL_REPORT_DATA_TRUNCATION, MYSQL_OPT_RECONNECT
  );

  MYSQL_RPL_TYPE = (MYSQL_RPL_MASTER, MYSQL_RPL_SLAVE, MYSQL_RPL_ADMIN);

  MYSQL_SET_OPTION = (MYSQL_OPTION_MULTI_STATEMENTS_ON, MYSQL_OPTION_MULTI_STATEMENTS_OFF);

  MYSQL_SHUTDOWN_LEVEL = (
    SHUTDOWN_DEFAULT = 0,
    SHUTDOWN_WAIT_CONNECTIONS = 1,
    SHUTDOWN_WAIT_TRANSACTIONS = 2,
    SHUTDOWN_WAIT_UPDATES = 8,
    SHUTDOWN_WAIT_ALL_BUFFERS = 16,
    SHUTDOWN_WAIT_CRITICAL_BUFFERS = 17,
    KILL_QUERY = 254,
    KILL_CONNECTION = 255
  );

  plist = ^st_list;
  st_list = record
    prev, next: plist;
    data: Pointer;
  end;
  LIST = st_list;

  st_vio = record end; // пустая структура: кому нужна - не понятно. ;)
  VIO = st_vio;

  st_net = record
    vio: ^VIO;
    buff, buff_end, write_pos, read_pos: PChar;
    fd: my_socket;
    max_packet, max_packet_size: LongWord;
    pkt_nr, compress_pkt_nr: LongWord;
    write_timeout, read_timeout, retry_count: LongWord;
    fcntl: Integer;
    compress: my_bool;

    remain_in_buf, length, buf_length, where_b: LongWord;
    return_status: PLongWord;
    reading_or_writing: Char;

    save_char: Char;

    no_send_ok: my_bool;
    no_send_eof: my_bool;

    no_send_error: my_bool;

    last_error: array [0..MYSQL_ERRMSG_SIZE-1] of char;
    sqlstate: array [0..SQLSTATE_LENGTH] of char;

    last_errno: LongWord;
    error: char;

    query_cache_query: gptr;

    report_error: my_bool;
    return_errno: my_bool;
  end;
  NET = st_net;

  pmysql_field = ^st_mysql_field;
  st_mysql_field = record
    name, org_name,
    table, org_table,
    db,
    catalog,
    def: pchar;
    length, max_length,
    name_length, org_name_length,
    table_length, org_table_length,
    db_length, catalog_length,
    def_length,
    flags, decimals,
    charsetnr: Cardinal;
    _type: enum_field_types;
  end;
  MYSQL_FIELD = st_mysql_field;

  mysql_fields = array [0..$ff] of MYSQL_FIELD;
  pmysql_fields = ^mysql_fields;

  pused_mem = ^st_used_mem;
  st_used_mem = record
    next: pused_mem;
    left, size: LongWord;
  end;
  USED_MEM = st_used_mem;

  st_mem_root = record
    free: pused_mem;
    used: pused_mem;
    pre_alloc: pused_mem;
    min_malloc: LongWord;
    block_size: LongWord;
    block_num: LongWord;
    first_block_usage: LongWord;

    error_handler: Pointer;
  end;
  MEM_ROOT = st_mem_root;

  pdynamic_array = ^st_dynamic_array;
  st_dynamic_array = record
    buffer: PChar;
    elements, max_element: LongWord;
    alloc_increment: LongWord;
    size_of_element: LongWord;
  end;
  DYNAMIC_ARRAY = st_dynamic_array;

  st_mysql_options = record
    connect_timeout, read_timeout, write_timeout: LongWord;
    port, protocol: LongWord;
    client_flag: LongWord;

    host, user, password, unix_socket, db: PChar;

    init_commands: pdynamic_array;

    my_cnf_file, my_cnf_group, charset_dir, charset_name: PChar;

    ssl_key: PChar;
    ssl_cert: PChar;
    ssl_ca: PChar;
    ssl_capath: PChar;
    ssl_cipher: PChar;
    shared_memory_base_name: PChar;

    max_allowed_packet: LongWord;

    use_ssl: my_bool;
    compress, named_pipe: my_bool;

    rpl_probe: my_bool;
    rpl_parse: my_bool;

    no_master_reads: my_bool;

    separate_thread: my_bool;

    methods_to_use: MYSQL_OPTION;
    client_ip: PChar;

    secure_auth: my_bool;
    report_data_truncation: my_bool;

    local_infile_init: Pointer;
    local_infile_read: Pointer;
    local_infile_end: Pointer;
    local_infile_error: Pointer;
    local_infile_userdata: Pointer;
  end;

  pmysql_methods = ^st_mysql_methods;
  st_mysql_methods = record
(* // Лень писать: что-то я не понял зачем эта структура надо...

typedef struct st_mysql_methods
{
  my_bool (*read_query_result)(MYSQL *mysql);
  my_bool (*advanced_command)(MYSQL *mysql,
			      enum enum_server_command command,
			      const char *header,
			      unsigned long header_length,
			      const char *arg,
			      unsigned long arg_length,
			      my_bool skip_check);
  MYSQL_DATA *(*read_rows)(MYSQL *mysql,MYSQL_FIELD *mysql_fields,
			   unsigned int fields);
  MYSQL_RES * (*use_result)(MYSQL *mysql);
  void (*fetch_lengths)(unsigned long *to,
			MYSQL_ROW column, unsigned int field_count);
  void (*flush_use_result)(MYSQL *mysql);
#if !defined(MYSQL_SERVER) || defined(EMBEDDED_LIBRARY)
  MYSQL_FIELD * (*list_fields)(MYSQL *mysql);
  my_bool (*read_prepare_result)(MYSQL *mysql, MYSQL_STMT *stmt);
  int (*stmt_execute)(MYSQL_STMT *stmt);
  int (*read_binary_rows)(MYSQL_STMT *stmt);
  int (*unbuffered_fetch)(MYSQL *mysql, char **row);
  void (*free_embedded_thd)(MYSQL *mysql);
  const char *(*read_statistics)(MYSQL *mysql);
  my_bool (*next_result)(MYSQL *mysql);
  int (*read_change_user_result)(MYSQL *mysql, char *buff, const char *passwd);
  int (*read_rows_from_cursor)(MYSQL_STMT *stmt);
#endif
} MYSQL_METHODS;


*)
  end;
  MYSQL_METHODS = st_mysql_methods;

  pembedded_query_result = ^st_embedded_query_result;
  st_embedded_query_result = record
  end;
  EMBEDDED_QUERY_RESULT = st_embedded_query_result;

  pmysql_row = ^MYSQL_ROW;
  MYSQL_ROW = array[0..255] of PChar;

  pmysql_rows = ^st_mysql_rows;
  st_mysql_rows = record
    next: pmysql_rows;
    data: MYSQL_ROW;
    length: LongWord;
  end;
  MYSQL_ROWS = st_mysql_rows;

  pmysql_data = ^st_mysql_data;
  st_mysql_data = record
    rows: my_ulonglong;
    fields: LongWord;
    data: pmysql_rows;
    alloc: MEM_ROOT;

    embedded_info: pembedded_query_result;
  end;
  MYSQL_DATA = st_mysql_data;

  pmysql = ^st_mysql;
  st_mysql = record
    net: NET;
    connector_fd: gptr;
    host, user, passwd, unix_socket, server_version, host_info, info: PChar;
    db: PChar;
    charset: pmy_charset_info;
    fields: pmysql_field;
    field_alloc: MEM_ROOT;
    affected_rows: my_ulonglong;
    insert_id: my_ulonglong;
    extra_info: my_ulonglong;
    thread_id: LongWord;
    packet_length: LongWord;
    port: LongWord;
    client_flag, server_capabilities: LongWord;
    protocol_version: LongWord;
    field_count: LongWord;
    server_status: LongWord;
    server_language: LongWord;
    warning_count: LongWord;
    options: st_mysql_options;
    status: mysql_status;
    free_me: my_bool;
    reconnect: my_bool;
    scramble: array [0..SCRAMBLE_LENGTH] of char;
    rpl_pivot: my_bool;

    master, next_slave: pmysql;
    last_used_slave: pmysql;
    last_used_con: pmysql;

    stmts: plist;

    methods: pmysql_methods;

    thd: Pointer;

    unbuffered_fetch_owner: pmy_bool;

    info_buffer: PChar;
  end;
  _MYSQL = st_mysql;

  pmysql_res = ^st_mysql_res;
  st_mysql_res = record
    row_count: my_ulonglong;
    fields: pmysql_field;
    data: pmysql_data;
    data_cursor: pmysql_rows;
    lengths: PLongWord;
    handle: pmysql;
    field_alloc: MEM_ROOT;
    field_count, current_field: LongWord;
    row: MYSQL_ROW;
    current_row: MYSQL_ROW;
    eof: my_bool;
    unbuffered_fetch_cancelled: my_bool;

    methods: pmysql_methods;
  end;
  MYSQL_RES = st_mysql_res;

  pmysql_parameters = ^st_mysql_parameters;
  st_mysql_parameters = record
    p_max_allowed_packet: PLongWord;
    p_net_buffer_length: PLongWord;
  end;
  MYSQL_PARAMETERS = st_mysql_parameters;

function mysql_affected_rows(mysql: pmysql): LongWord; stdcall;
function mysql_autocommit(mysql: pmysql; auto_mode: my_bool): my_bool; stdcall;
function mysql_change_user(mysql: pmysql; user, passwd, db: PChar): my_bool; stdcall;
function mysql_character_set_name(mysql: pmysql): PChar; stdcall;
procedure mysql_close(mysql: pmysql); stdcall;
function mysql_commit(mysql: pmysql): my_bool; stdcall;
procedure mysql_data_seek(result: pmysql_res; offset: my_ulonglong); stdcall;
procedure mysql_debug(debug: PChar); stdcall;
procedure mysql_disable_reads_from_master(mysql: pmysql); stdcall;
procedure mysql_disable_rpl_parse(mysql: pmysql); stdcall;
function mysql_dump_debug_info(mysql: pmysql): Integer; stdcall;
function mysql_embedded(): my_bool; stdcall;
procedure mysql_enable_reads_from_master(mysql: pmysql); stdcall;
procedure mysql_enable_rpl_parse(mysql: pmysql); stdcall;
function mysql_eof(result: pmysql_res): my_bool; stdcall;
function mysql_errno(mysql: pmysql): Integer; stdcall;
function mysql_error(mysql: pmysql): PChar; stdcall;
function mysql_escape_string(ato: PChar; from: PChar; from_length: LongWord): LongWord; stdcall;
function mysql_fetch_field(result: pmysql_res): pmysql_field; stdcall;
function mysql_fetch_field_direct(result: pmysql_res; fieldnr: LongWord): pmysql_field; stdcall;
function mysql_fetch_fields(result: pmysql_res): pmysql_fields; stdcall;
function mysql_fetch_lengths(result: pmysql_res): LongWord; stdcall;
function mysql_fetch_row(result: pmysql_res): pmysql_row; stdcall;
function mysql_field_count(result: pmysql_res): LongWord; stdcall;
function mysql_field_seek(result: pmysql_res; offset: MYSQL_FIELD_OFFSET): MYSQL_FIELD_OFFSET; stdcall;
function mysql_field_tell(result: pmysql_res): MYSQL_FIELD_OFFSET; stdcall;
procedure mysql_free_result(mysql: pmysql_res); stdcall;
procedure mysql_get_character_set_info(mysql: pmysql; charset: pmy_charset_info); stdcall;
function mysql_get_client_info(): PChar; stdcall;
function mysql_get_client_version(): LongWord; stdcall;
function mysql_get_host_info(): PChar; stdcall;
function mysql_get_parameters(): pmysql_parameters;
function mysql_get_proto_info(mysql: pmysql): Integer; stdcall;
function mysql_get_server_info(mysql: pmysql): PChar; stdcall;
function mysql_get_server_version(mysql: pmysql): Integer; stdcall;
function mysql_hex_string(ato: PChar; from: PChar; from_length: LongWord): LongWord; stdcall;
function mysql_info(mysql: pmysql): PChar; stdcall;
function mysql_init(mysql: pmysql): pmysql; stdcall;
function mysql_insert_id(mysql: pmysql): my_ulonglong; stdcall;
function mysql_kill(mysql: pmysql; pid: LongWord): Integer; stdcall;
function mysql_list_dbs(mysql: pmysql; wild: PChar): pmysql_res; stdcall;
function mysql_list_fields(mysql: pmysql; table: PChar; wild: PChar): pmysql_res; stdcall;
function mysql_list_processes(mysql: pmysql): pmysql_res; stdcall;
function mysql_list_tables(mysql: pmysql; wild: PChar): pmysql_res; stdcall;
function mysql_master_query(mysql: pmysql; q: PChar; length: LongWord): my_bool; stdcall;
function mysql_more_results(mysql: pmysql): my_bool; stdcall;
function mysql_next_result(mysql: pmysql): Integer; stdcall;
function mysql_num_fields(result: pmysql_res): LongWord; stdcall;
function mysql_num_rows(result: pmysql_res): LongWord; stdcall;
// mysql_odbc_escape_string
function mysql_options(mysql: pmysql; option: MYSQL_OPTION; arg: PChar): Integer; stdcall;
function mysql_ping(mysql: pmysql): Integer; stdcall;
function mysql_query(mysql: pmysql; q: PChar): Integer; stdcall;
function mysql_read_query_result(mysql: pmysql): my_bool; stdcall;
function mysql_real_connect(mysql: pmysql; const host, user, passwd, db: pchar; port: Cardinal; unix_socket: PChar; clientflag: Cardinal): pmysql; stdcall;
function mysql_real_escape_string(mysql: pmysql; ato: PChar; from: PChar; from_length: LongWord): LongWord; stdcall;
function mysql_real_query(mysql: pmysql; q: PChar; length: LongWord): Integer; stdcall;
function mysql_refresh(mysql: pmysql; refresh_options: LongWord): Integer; stdcall;
function mysql_rollback(mysql: pmysql): my_bool; stdcall;
function mysql_row_seek(result: pmysql_res; offset: MYSQL_ROW_OFFSET): MYSQL_ROW_OFFSET; stdcall;
function mysql_row_tell(result: pmysql_res): MYSQL_ROW_OFFSET; stdcall;
function mysql_rpl_parse_enabled(mysql: pmysql): Integer; stdcall;
function mysql_rpl_probe(mysql: pmysql): my_bool; stdcall;
function mysql_rpl_query_type(q: PChar; length: Integer): MYSQL_RPL_TYPE; stdcall;
function mysql_select_db(mysql: pmysql; db: PChar): Integer; stdcall;
function mysql_send_query(mysql: pmysql; q: PChar; length: LongWord): Integer; stdcall;
procedure mysql_server_end(); stdcall;
function mysql_server_init(argc: Integer; argv: Pointer; groups: Pointer): Integer; stdcall;
function mysql_set_character_set(mysql: pmysql; csname: PChar): Integer; stdcall;
procedure mysql_set_local_infile_default(mysql: pmysql); stdcall;
// mysql_set_local_infile_handler
function mysql_set_server_option(mysql: pmysql; option: MYSQL_SET_OPTION): Integer; stdcall;
function mysql_shutdown(mysql: pmysql; shutdown_level: MYSQL_SHUTDOWN_LEVEL): Integer; stdcall;
function mysql_slave_query(mysql: pmysql; q: PChar; length: LongWord): Integer; stdcall;
function mysql_sqlstate(mysql: pmysql): PChar; stdcall;
// mysql_ssl_set
function mysql_stat(mysql: pmysql): pchar; stdcall;
function mysql_store_result(mysql: pmysql): pmysql_res; stdcall;
// mysql_thread_end
// mysql_thread_id
// mysql_thread_init
// mysql_thread_safe
function mysql_use_result(mysql: pmysql): pmysql_res; stdcall;
function mysql_warning_count(mysql: pmysql): Integer; stdcall;


implementation

function mysql_affected_rows(mysql: pmysql): LongWord; stdcall; external libmySQL;
function mysql_autocommit(mysql: pmysql; auto_mode: my_bool): my_bool; stdcall; external libmySQL;
function mysql_change_user(mysql: pmysql; user, passwd, db: PChar): my_bool; stdcall; external libmySQL;
function mysql_character_set_name(mysql: pmysql): PChar; stdcall; external libmySQL;
procedure mysql_close(mysql: pmysql); stdcall; external libmySQL;
function mysql_commit(mysql: pmysql): my_bool; stdcall; external libmySQL;
procedure mysql_data_seek(result: pmysql_res; offset: my_ulonglong); stdcall; external libmySQL;
procedure mysql_debug(debug: PChar); stdcall; external libmySQL;
procedure mysql_disable_reads_from_master(mysql: pmysql); stdcall; external libmySQL;
procedure mysql_disable_rpl_parse(mysql: pmysql); stdcall; external libmySQL;
function mysql_dump_debug_info(mysql: pmysql): Integer; stdcall; external libmySQL;
function mysql_embedded(): my_bool; stdcall; external libmySQL;
procedure mysql_enable_reads_from_master(mysql: pmysql); stdcall; external libmySQL;
procedure mysql_enable_rpl_parse(mysql: pmysql); stdcall; external libmySQL;
function mysql_eof(result: pmysql_res): my_bool; stdcall; external libmySQL;
function mysql_errno(mysql: pmysql): Integer; stdcall; external libmySQL;
function mysql_error(mysql: pmysql): PChar; stdcall; external libmySQL;
function mysql_escape_string(ato: PChar; from: PChar; from_length: LongWord): LongWord; stdcall; external libmySQL;
function mysql_fetch_field(result: pmysql_res): pmysql_field; stdcall; external libmySQL;
function mysql_fetch_field_direct(result: pmysql_res; fieldnr: LongWord): pmysql_field; stdcall; external libmySQL;
function mysql_fetch_fields(result: pmysql_res): pmysql_fields; stdcall; external libmySQL;
function mysql_fetch_lengths(result: pmysql_res): LongWord; stdcall; external libmySQL;
function mysql_fetch_row(result: pmysql_res): pmysql_row; stdcall; external libmySQL;
function mysql_field_count(result: pmysql_res): LongWord; stdcall; external libmySQL;
function mysql_field_seek(result: pmysql_res; offset: MYSQL_FIELD_OFFSET): MYSQL_FIELD_OFFSET; stdcall; external libmySQL;
function mysql_field_tell(result: pmysql_res): MYSQL_FIELD_OFFSET; stdcall; external libmySQL;
procedure mysql_free_result(mysql: pmysql_res); stdcall; external libmySQL;
procedure mysql_get_character_set_info(mysql: pmysql; charset: pmy_charset_info); stdcall; external libmySQL;
function mysql_get_client_info(): PChar; stdcall; external libmySQL;
function mysql_get_client_version(): LongWord; stdcall; external libmySQL;
function mysql_get_host_info(): PChar; stdcall; external libmySQL;
function mysql_get_parameters(): pmysql_parameters; external libmySQL;
function mysql_get_proto_info(mysql: pmysql): Integer; stdcall; external libmySQL;
function mysql_get_server_info(mysql: pmysql): PChar; stdcall; external libmySQL;
function mysql_get_server_version(mysql: pmysql): Integer; stdcall; external libmySQL;
function mysql_hex_string(ato: PChar; from: PChar; from_length: LongWord): LongWord; stdcall; external libmySQL;
function mysql_info(mysql: pmysql): PChar; stdcall; external libmySQL;
function mysql_init(mysql: pmysql): pmysql; stdcall; external libmySQL;
function mysql_insert_id(mysql: pmysql): my_ulonglong; stdcall; external libmySQL;
function mysql_kill(mysql: pmysql; pid: LongWord): Integer; stdcall; external libmySQL;
function mysql_list_dbs(mysql: pmysql; wild: PChar): pmysql_res; stdcall; external libmySQL;
function mysql_list_fields(mysql: pmysql; table: PChar; wild: PChar): pmysql_res; stdcall; external libmySQL;
function mysql_list_processes(mysql: pmysql): pmysql_res; stdcall; external libmySQL;
function mysql_list_tables(mysql: pmysql; wild: PChar): pmysql_res; stdcall; external libmySQL;
function mysql_master_query(mysql: pmysql; q: PChar; length: LongWord): my_bool; stdcall; external libmySQL;
function mysql_more_results(mysql: pmysql): my_bool; stdcall; external libmySQL;
function mysql_next_result(mysql: pmysql): Integer; stdcall; external libmySQL;
function mysql_num_fields(result: pmysql_res): LongWord; stdcall; external libmySQL;
function mysql_num_rows(result: pmysql_res): LongWord; stdcall; external libmySQL;
function mysql_options(mysql: pmysql; option: MYSQL_OPTION; arg: PChar): Integer; stdcall; external libmySQL;
function mysql_ping(mysql: pmysql): Integer; stdcall; external libmySQL;
function mysql_query(mysql: pmysql; q: PChar): Integer; stdcall; external libmySQL;
function mysql_read_query_result(mysql: pmysql): my_bool; stdcall; external libmySQL;
function mysql_real_connect(mysql: pmysql; const host, user, passwd, db: pchar; port: Cardinal; unix_socket: PChar; clientflag: Cardinal): pmysql; stdcall; external libmySQL;
function mysql_real_escape_string(mysql: pmysql; ato: PChar; from: PChar; from_length: LongWord): LongWord; stdcall; external libmySQL;
function mysql_real_query(mysql: pmysql; q: PChar; length: LongWord): Integer; stdcall; external libmySQL;
function mysql_refresh(mysql: pmysql; refresh_options: LongWord): Integer; stdcall; external libmySQL;
function mysql_rollback(mysql: pmysql): my_bool; stdcall; external libmySQL;
function mysql_row_seek(result: pmysql_res; offset: MYSQL_ROW_OFFSET): MYSQL_ROW_OFFSET; stdcall; external libmySQL;
function mysql_row_tell(result: pmysql_res): MYSQL_ROW_OFFSET; stdcall; external libmySQL;
function mysql_rpl_parse_enabled(mysql: pmysql): Integer; stdcall; external libmySQL;
function mysql_rpl_probe(mysql: pmysql): my_bool; stdcall; external libmySQL;
function mysql_rpl_query_type(q: PChar; length: Integer): MYSQL_RPL_TYPE; stdcall; external libmySQL;
function mysql_select_db(mysql: pmysql; db: PChar): Integer; stdcall; external libmySQL;
function mysql_send_query(mysql: pmysql; q: PChar; length: LongWord): Integer; stdcall; external libmySQL;
procedure mysql_server_end(); stdcall; external libmySQL;
function mysql_server_init(argc: Integer; argv: Pointer; groups: Pointer): Integer; stdcall; external libmySQL;
function mysql_set_character_set(mysql: pmysql; csname: PChar): Integer; stdcall; external libmySQL;
procedure mysql_set_local_infile_default(mysql: pmysql); stdcall; external libmySQL;
function mysql_set_server_option(mysql: pmysql; option: MYSQL_SET_OPTION): Integer; stdcall; external libmySQL;
function mysql_shutdown(mysql: pmysql; shutdown_level: MYSQL_SHUTDOWN_LEVEL): Integer; stdcall; external libmySQL;
function mysql_slave_query(mysql: pmysql; q: PChar; length: LongWord): Integer; stdcall; external libmySQL;
function mysql_sqlstate(mysql: pmysql): PChar; stdcall; external libmySQL;
function mysql_stat(mysql: pmysql): pchar; stdcall; external libmySQL;
function mysql_store_result(mysql: pmysql): pmysql_res; stdcall; external libmySQL;
function mysql_use_result(mysql: pmysql): pmysql_res; stdcall; external libmySQL;
function mysql_warning_count(mysql: pmysql): Integer; stdcall; external libmySQL;

end.
