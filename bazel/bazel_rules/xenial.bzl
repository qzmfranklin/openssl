

def openssl():
    # TODO: crypto.copts and ssl.copts are identical except for the -I
    # directives, which are superseded by the includes attribute anyways.
    # Should consolidate the copts for crypto and ssl.

    openssl_includes = [
        'include',
        'crypto',
        'crypto/include',
        'crypto/bn',
        'crypto/des',
        'crypto/modes',
        # The generated headers are stored in the $(GENDIR).
        '$(GENDIR)/%s/include' % PACKAGE_NAME,
        '$(GENDIR)/%s/crypto' % PACKAGE_NAME,
        '$(GENDIR)/%s/crypto/include' % PACKAGE_NAME,
    ]

    if PACKAGE_NAME:
        openssl_includes += [ '.' ]

    crypto_textual_hrds = [
        'crypto/LPdir_unix.c',
        'crypto/ec/ecp_nistz256_table.c',
        'crypto/des/ncbc_enc.c',
    ]

    openssl_linkopts = ['-pthread', '-m64']

    native.cc_library(
        name = 'crypto',
        visibility = [
            '//visibility:public',
        ],
        srcs = ['crypto/aes/aes-x86_64.s', 'crypto/aes/aes_cfb.c', 'crypto/aes/aes_ecb.c', 'crypto/aes/aes_ige.c', 'crypto/aes/aes_misc.c', 'crypto/aes/aes_ofb.c', 'crypto/aes/aes_wrap.c', 'crypto/aes/aesni-mb-x86_64.s', 'crypto/aes/aesni-sha1-x86_64.s', 'crypto/aes/aesni-sha256-x86_64.s', 'crypto/aes/aesni-x86_64.s', 'crypto/aes/bsaes-x86_64.s', 'crypto/aes/vpaes-x86_64.s', 'crypto/asn1/a_bitstr.c', 'crypto/asn1/a_d2i_fp.c', 'crypto/asn1/a_digest.c', 'crypto/asn1/a_dup.c', 'crypto/asn1/a_gentm.c', 'crypto/asn1/a_i2d_fp.c', 'crypto/asn1/a_int.c', 'crypto/asn1/a_mbstr.c', 'crypto/asn1/a_object.c', 'crypto/asn1/a_octet.c', 'crypto/asn1/a_print.c', 'crypto/asn1/a_sign.c', 'crypto/asn1/a_strex.c', 'crypto/asn1/a_strnid.c', 'crypto/asn1/a_time.c', 'crypto/asn1/a_type.c', 'crypto/asn1/a_utctm.c', 'crypto/asn1/a_utf8.c', 'crypto/asn1/a_verify.c', 'crypto/asn1/ameth_lib.c', 'crypto/asn1/asn1_err.c', 'crypto/asn1/asn1_gen.c', 'crypto/asn1/asn1_item_list.c', 'crypto/asn1/asn1_lib.c', 'crypto/asn1/asn1_par.c', 'crypto/asn1/asn_mime.c', 'crypto/asn1/asn_moid.c', 'crypto/asn1/asn_mstbl.c', 'crypto/asn1/asn_pack.c', 'crypto/asn1/bio_asn1.c', 'crypto/asn1/bio_ndef.c', 'crypto/asn1/d2i_pr.c', 'crypto/asn1/d2i_pu.c', 'crypto/asn1/evp_asn1.c', 'crypto/asn1/f_int.c', 'crypto/asn1/f_string.c', 'crypto/asn1/i2d_pr.c', 'crypto/asn1/i2d_pu.c', 'crypto/asn1/n_pkey.c', 'crypto/asn1/nsseq.c', 'crypto/asn1/p5_pbe.c', 'crypto/asn1/p5_pbev2.c', 'crypto/asn1/p5_scrypt.c', 'crypto/asn1/p8_pkey.c', 'crypto/asn1/t_bitst.c', 'crypto/asn1/t_pkey.c', 'crypto/asn1/t_spki.c', 'crypto/asn1/tasn_dec.c', 'crypto/asn1/tasn_enc.c', 'crypto/asn1/tasn_fre.c', 'crypto/asn1/tasn_new.c', 'crypto/asn1/tasn_prn.c', 'crypto/asn1/tasn_scn.c', 'crypto/asn1/tasn_typ.c', 'crypto/asn1/tasn_utl.c', 'crypto/asn1/x_algor.c', 'crypto/asn1/x_bignum.c', 'crypto/asn1/x_info.c', 'crypto/asn1/x_int64.c', 'crypto/asn1/x_long.c', 'crypto/asn1/x_pkey.c', 'crypto/asn1/x_sig.c', 'crypto/asn1/x_spki.c', 'crypto/asn1/x_val.c', 'crypto/async/arch/async_null.c', 'crypto/async/arch/async_posix.c', 'crypto/async/arch/async_win.c', 'crypto/async/async.c', 'crypto/async/async_err.c', 'crypto/async/async_wait.c', 'crypto/bf/bf_cfb64.c', 'crypto/bf/bf_ecb.c', 'crypto/bf/bf_enc.c', 'crypto/bf/bf_ofb64.c', 'crypto/bf/bf_skey.c', 'crypto/bio/b_addr.c', 'crypto/bio/b_dump.c', 'crypto/bio/b_print.c', 'crypto/bio/b_sock.c', 'crypto/bio/b_sock2.c', 'crypto/bio/bf_buff.c', 'crypto/bio/bf_lbuf.c', 'crypto/bio/bf_nbio.c', 'crypto/bio/bf_null.c', 'crypto/bio/bio_cb.c', 'crypto/bio/bio_err.c', 'crypto/bio/bio_lib.c', 'crypto/bio/bio_meth.c', 'crypto/bio/bss_acpt.c', 'crypto/bio/bss_bio.c', 'crypto/bio/bss_conn.c', 'crypto/bio/bss_dgram.c', 'crypto/bio/bss_fd.c', 'crypto/bio/bss_file.c', 'crypto/bio/bss_log.c', 'crypto/bio/bss_mem.c', 'crypto/bio/bss_null.c', 'crypto/bio/bss_sock.c', 'crypto/blake2/blake2b.c', 'crypto/blake2/blake2s.c', 'crypto/blake2/m_blake2b.c', 'crypto/blake2/m_blake2s.c', 'crypto/bn/asm/x86_64-gcc.c', 'crypto/bn/bn_add.c', 'crypto/bn/bn_blind.c', 'crypto/bn/bn_const.c', 'crypto/bn/bn_ctx.c', 'crypto/bn/bn_depr.c', 'crypto/bn/bn_dh.c', 'crypto/bn/bn_div.c', 'crypto/bn/bn_err.c', 'crypto/bn/bn_exp.c', 'crypto/bn/bn_exp2.c', 'crypto/bn/bn_gcd.c', 'crypto/bn/bn_gf2m.c', 'crypto/bn/bn_intern.c', 'crypto/bn/bn_kron.c', 'crypto/bn/bn_lib.c', 'crypto/bn/bn_mod.c', 'crypto/bn/bn_mont.c', 'crypto/bn/bn_mpi.c', 'crypto/bn/bn_mul.c', 'crypto/bn/bn_nist.c', 'crypto/bn/bn_prime.c', 'crypto/bn/bn_print.c', 'crypto/bn/bn_rand.c', 'crypto/bn/bn_recp.c', 'crypto/bn/bn_shift.c', 'crypto/bn/bn_sqr.c', 'crypto/bn/bn_sqrt.c', 'crypto/bn/bn_srp.c', 'crypto/bn/bn_word.c', 'crypto/bn/bn_x931p.c', 'crypto/bn/rsaz-avx2.s', 'crypto/bn/rsaz-x86_64.s', 'crypto/bn/rsaz_exp.c', 'crypto/bn/x86_64-gf2m.s', 'crypto/bn/x86_64-mont.s', 'crypto/bn/x86_64-mont5.s', 'crypto/buffer/buf_err.c', 'crypto/buffer/buffer.c', 'crypto/camellia/cmll-x86_64.s', 'crypto/camellia/cmll_cfb.c', 'crypto/camellia/cmll_ctr.c', 'crypto/camellia/cmll_ecb.c', 'crypto/camellia/cmll_misc.c', 'crypto/camellia/cmll_ofb.c', 'crypto/cast/c_cfb64.c', 'crypto/cast/c_ecb.c', 'crypto/cast/c_enc.c', 'crypto/cast/c_ofb64.c', 'crypto/cast/c_skey.c', 'crypto/chacha/chacha-x86_64.s', 'crypto/cmac/cm_ameth.c', 'crypto/cmac/cm_pmeth.c', 'crypto/cmac/cmac.c', 'crypto/cms/cms_asn1.c', 'crypto/cms/cms_att.c', 'crypto/cms/cms_cd.c', 'crypto/cms/cms_dd.c', 'crypto/cms/cms_enc.c', 'crypto/cms/cms_env.c', 'crypto/cms/cms_err.c', 'crypto/cms/cms_ess.c', 'crypto/cms/cms_io.c', 'crypto/cms/cms_kari.c', 'crypto/cms/cms_lib.c', 'crypto/cms/cms_pwri.c', 'crypto/cms/cms_sd.c', 'crypto/cms/cms_smime.c', 'crypto/comp/c_zlib.c', 'crypto/comp/comp_err.c', 'crypto/comp/comp_lib.c', 'crypto/conf/conf_api.c', 'crypto/conf/conf_def.c', 'crypto/conf/conf_err.c', 'crypto/conf/conf_lib.c', 'crypto/conf/conf_mall.c', 'crypto/conf/conf_mod.c', 'crypto/conf/conf_sap.c', 'crypto/cpt_err.c', 'crypto/cryptlib.c', 'crypto/ct/ct_b64.c', 'crypto/ct/ct_err.c', 'crypto/ct/ct_log.c', 'crypto/ct/ct_oct.c', 'crypto/ct/ct_policy.c', 'crypto/ct/ct_prn.c', 'crypto/ct/ct_sct.c', 'crypto/ct/ct_sct_ctx.c', 'crypto/ct/ct_vfy.c', 'crypto/ct/ct_x509v3.c', 'crypto/cversion.c', 'crypto/des/cbc_cksm.c', 'crypto/des/cbc_enc.c', 'crypto/des/cfb64ede.c', 'crypto/des/cfb64enc.c', 'crypto/des/cfb_enc.c', 'crypto/des/des_enc.c', 'crypto/des/ecb3_enc.c', 'crypto/des/ecb_enc.c', 'crypto/des/fcrypt.c', 'crypto/des/fcrypt_b.c', 'crypto/des/ofb64ede.c', 'crypto/des/ofb64enc.c', 'crypto/des/ofb_enc.c', 'crypto/des/pcbc_enc.c', 'crypto/des/qud_cksm.c', 'crypto/des/rand_key.c', 'crypto/des/set_key.c', 'crypto/des/str2key.c', 'crypto/des/xcbc_enc.c', 'crypto/dh/dh_ameth.c', 'crypto/dh/dh_asn1.c', 'crypto/dh/dh_check.c', 'crypto/dh/dh_depr.c', 'crypto/dh/dh_err.c', 'crypto/dh/dh_gen.c', 'crypto/dh/dh_kdf.c', 'crypto/dh/dh_key.c', 'crypto/dh/dh_lib.c', 'crypto/dh/dh_meth.c', 'crypto/dh/dh_pmeth.c', 'crypto/dh/dh_prn.c', 'crypto/dh/dh_rfc5114.c', 'crypto/dsa/dsa_ameth.c', 'crypto/dsa/dsa_asn1.c', 'crypto/dsa/dsa_depr.c', 'crypto/dsa/dsa_err.c', 'crypto/dsa/dsa_gen.c', 'crypto/dsa/dsa_key.c', 'crypto/dsa/dsa_lib.c', 'crypto/dsa/dsa_meth.c', 'crypto/dsa/dsa_ossl.c', 'crypto/dsa/dsa_pmeth.c', 'crypto/dsa/dsa_prn.c', 'crypto/dsa/dsa_sign.c', 'crypto/dsa/dsa_vrf.c', 'crypto/dso/dso_dl.c', 'crypto/dso/dso_dlfcn.c', 'crypto/dso/dso_err.c', 'crypto/dso/dso_lib.c', 'crypto/dso/dso_openssl.c', 'crypto/dso/dso_vms.c', 'crypto/dso/dso_win32.c', 'crypto/ebcdic.c', 'crypto/ec/curve25519.c', 'crypto/ec/ec2_mult.c', 'crypto/ec/ec2_oct.c', 'crypto/ec/ec2_smpl.c', 'crypto/ec/ec_ameth.c', 'crypto/ec/ec_asn1.c', 'crypto/ec/ec_check.c', 'crypto/ec/ec_curve.c', 'crypto/ec/ec_cvt.c', 'crypto/ec/ec_err.c', 'crypto/ec/ec_key.c', 'crypto/ec/ec_kmeth.c', 'crypto/ec/ec_lib.c', 'crypto/ec/ec_mult.c', 'crypto/ec/ec_oct.c', 'crypto/ec/ec_pmeth.c', 'crypto/ec/ec_print.c', 'crypto/ec/ecdh_kdf.c', 'crypto/ec/ecdh_ossl.c', 'crypto/ec/ecdsa_ossl.c', 'crypto/ec/ecdsa_sign.c', 'crypto/ec/ecdsa_vrf.c', 'crypto/ec/eck_prn.c', 'crypto/ec/ecp_mont.c', 'crypto/ec/ecp_nist.c', 'crypto/ec/ecp_nistp224.c', 'crypto/ec/ecp_nistp256.c', 'crypto/ec/ecp_nistp521.c', 'crypto/ec/ecp_nistputil.c', 'crypto/ec/ecp_nistz256-x86_64.s', 'crypto/ec/ecp_nistz256.c', 'crypto/ec/ecp_oct.c', 'crypto/ec/ecp_smpl.c', 'crypto/ec/ecx_meth.c', 'crypto/engine/eng_all.c', 'crypto/engine/eng_cnf.c', 'crypto/engine/eng_ctrl.c', 'crypto/engine/eng_dyn.c', 'crypto/engine/eng_err.c', 'crypto/engine/eng_fat.c', 'crypto/engine/eng_init.c', 'crypto/engine/eng_lib.c', 'crypto/engine/eng_list.c', 'crypto/engine/eng_openssl.c', 'crypto/engine/eng_pkey.c', 'crypto/engine/eng_rdrand.c', 'crypto/engine/eng_table.c', 'crypto/engine/tb_asnmth.c', 'crypto/engine/tb_cipher.c', 'crypto/engine/tb_dh.c', 'crypto/engine/tb_digest.c', 'crypto/engine/tb_dsa.c', 'crypto/engine/tb_eckey.c', 'crypto/engine/tb_pkmeth.c', 'crypto/engine/tb_rand.c', 'crypto/engine/tb_rsa.c', 'crypto/err/err.c', 'crypto/err/err_all.c', 'crypto/err/err_prn.c', 'crypto/evp/bio_b64.c', 'crypto/evp/bio_enc.c', 'crypto/evp/bio_md.c', 'crypto/evp/bio_ok.c', 'crypto/evp/c_allc.c', 'crypto/evp/c_alld.c', 'crypto/evp/cmeth_lib.c', 'crypto/evp/digest.c', 'crypto/evp/e_aes.c', 'crypto/evp/e_aes_cbc_hmac_sha1.c', 'crypto/evp/e_aes_cbc_hmac_sha256.c', 'crypto/evp/e_aria.c', 'crypto/evp/e_bf.c', 'crypto/evp/e_camellia.c', 'crypto/evp/e_cast.c', 'crypto/evp/e_chacha20_poly1305.c', 'crypto/evp/e_des.c', 'crypto/evp/e_des3.c', 'crypto/evp/e_idea.c', 'crypto/evp/e_null.c', 'crypto/evp/e_old.c', 'crypto/evp/e_rc2.c', 'crypto/evp/e_rc4.c', 'crypto/evp/e_rc4_hmac_md5.c', 'crypto/evp/e_rc5.c', 'crypto/evp/e_seed.c', 'crypto/evp/e_xcbc_d.c', 'crypto/evp/encode.c', 'crypto/evp/evp_cnf.c', 'crypto/evp/evp_enc.c', 'crypto/evp/evp_err.c', 'crypto/evp/evp_key.c', 'crypto/evp/evp_lib.c', 'crypto/evp/evp_pbe.c', 'crypto/evp/evp_pkey.c', 'crypto/evp/m_md2.c', 'crypto/evp/m_md4.c', 'crypto/evp/m_md5.c', 'crypto/evp/m_md5_sha1.c', 'crypto/evp/m_mdc2.c', 'crypto/evp/m_null.c', 'crypto/evp/m_ripemd.c', 'crypto/evp/m_sha1.c', 'crypto/evp/m_sha3.c', 'crypto/evp/m_sigver.c', 'crypto/evp/m_wp.c', 'crypto/evp/names.c', 'crypto/evp/p5_crpt.c', 'crypto/evp/p5_crpt2.c', 'crypto/evp/p_dec.c', 'crypto/evp/p_enc.c', 'crypto/evp/p_lib.c', 'crypto/evp/p_open.c', 'crypto/evp/p_seal.c', 'crypto/evp/p_sign.c', 'crypto/evp/p_verify.c', 'crypto/evp/pbe_scrypt.c', 'crypto/evp/pmeth_fn.c', 'crypto/evp/pmeth_gn.c', 'crypto/evp/pmeth_lib.c', 'crypto/ex_data.c', 'crypto/hmac/hm_ameth.c', 'crypto/hmac/hm_pmeth.c', 'crypto/hmac/hmac.c', 'crypto/idea/i_cbc.c', 'crypto/idea/i_cfb64.c', 'crypto/idea/i_ecb.c', 'crypto/idea/i_ofb64.c', 'crypto/idea/i_skey.c', 'crypto/init.c', 'crypto/kdf/hkdf.c', 'crypto/kdf/kdf_err.c', 'crypto/kdf/scrypt.c', 'crypto/kdf/tls1_prf.c', 'crypto/lhash/lh_stats.c', 'crypto/lhash/lhash.c', 'crypto/md4/md4_dgst.c', 'crypto/md4/md4_one.c', 'crypto/md5/md5-x86_64.s', 'crypto/md5/md5_dgst.c', 'crypto/md5/md5_one.c', 'crypto/mdc2/mdc2_one.c', 'crypto/mdc2/mdc2dgst.c', 'crypto/mem.c', 'crypto/mem_dbg.c', 'crypto/mem_sec.c', 'crypto/modes/aesni-gcm-x86_64.s', 'crypto/modes/cbc128.c', 'crypto/modes/ccm128.c', 'crypto/modes/cfb128.c', 'crypto/modes/ctr128.c', 'crypto/modes/cts128.c', 'crypto/modes/gcm128.c', 'crypto/modes/ghash-x86_64.s', 'crypto/modes/ocb128.c', 'crypto/modes/ofb128.c', 'crypto/modes/wrap128.c', 'crypto/modes/xts128.c', 'crypto/o_dir.c', 'crypto/o_fips.c', 'crypto/o_fopen.c', 'crypto/o_init.c', 'crypto/o_str.c', 'crypto/o_time.c', 'crypto/objects/o_names.c', 'crypto/objects/obj_dat.c', 'crypto/objects/obj_err.c', 'crypto/objects/obj_lib.c', 'crypto/objects/obj_xref.c', 'crypto/ocsp/ocsp_asn.c', 'crypto/ocsp/ocsp_cl.c', 'crypto/ocsp/ocsp_err.c', 'crypto/ocsp/ocsp_ext.c', 'crypto/ocsp/ocsp_ht.c', 'crypto/ocsp/ocsp_lib.c', 'crypto/ocsp/ocsp_prn.c', 'crypto/ocsp/ocsp_srv.c', 'crypto/ocsp/ocsp_vfy.c', 'crypto/ocsp/v3_ocsp.c', 'crypto/pem/pem_all.c', 'crypto/pem/pem_err.c', 'crypto/pem/pem_info.c', 'crypto/pem/pem_lib.c', 'crypto/pem/pem_oth.c', 'crypto/pem/pem_pk8.c', 'crypto/pem/pem_pkey.c', 'crypto/pem/pem_sign.c', 'crypto/pem/pem_x509.c', 'crypto/pem/pem_xaux.c', 'crypto/pem/pvkfmt.c', 'crypto/pkcs12/p12_add.c', 'crypto/pkcs12/p12_asn.c', 'crypto/pkcs12/p12_attr.c', 'crypto/pkcs12/p12_crpt.c', 'crypto/pkcs12/p12_crt.c', 'crypto/pkcs12/p12_decr.c', 'crypto/pkcs12/p12_init.c', 'crypto/pkcs12/p12_key.c', 'crypto/pkcs12/p12_kiss.c', 'crypto/pkcs12/p12_mutl.c', 'crypto/pkcs12/p12_npas.c', 'crypto/pkcs12/p12_p8d.c', 'crypto/pkcs12/p12_p8e.c', 'crypto/pkcs12/p12_sbag.c', 'crypto/pkcs12/p12_utl.c', 'crypto/pkcs12/pk12err.c', 'crypto/pkcs7/bio_pk7.c', 'crypto/pkcs7/pk7_asn1.c', 'crypto/pkcs7/pk7_attr.c', 'crypto/pkcs7/pk7_doit.c', 'crypto/pkcs7/pk7_lib.c', 'crypto/pkcs7/pk7_mime.c', 'crypto/pkcs7/pk7_smime.c', 'crypto/pkcs7/pkcs7err.c', 'crypto/poly1305/poly1305-x86_64.s', 'crypto/poly1305/poly1305.c', 'crypto/poly1305/poly1305_ameth.c', 'crypto/poly1305/poly1305_pmeth.c', 'crypto/rand/drbg_lib.c', 'crypto/rand/drbg_rand.c', 'crypto/rand/rand_egd.c', 'crypto/rand/rand_err.c', 'crypto/rand/rand_lib.c', 'crypto/rand/rand_unix.c', 'crypto/rand/rand_vms.c', 'crypto/rand/rand_win.c', 'crypto/rand/randfile.c', 'crypto/rc2/rc2_cbc.c', 'crypto/rc2/rc2_ecb.c', 'crypto/rc2/rc2_skey.c', 'crypto/rc2/rc2cfb64.c', 'crypto/rc2/rc2ofb64.c', 'crypto/rc4/rc4-md5-x86_64.s', 'crypto/rc4/rc4-x86_64.s', 'crypto/ripemd/rmd_dgst.c', 'crypto/ripemd/rmd_one.c', 'crypto/rsa/rsa_ameth.c', 'crypto/rsa/rsa_asn1.c', 'crypto/rsa/rsa_chk.c', 'crypto/rsa/rsa_crpt.c', 'crypto/rsa/rsa_depr.c', 'crypto/rsa/rsa_err.c', 'crypto/rsa/rsa_gen.c', 'crypto/rsa/rsa_lib.c', 'crypto/rsa/rsa_meth.c', 'crypto/rsa/rsa_none.c', 'crypto/rsa/rsa_oaep.c', 'crypto/rsa/rsa_ossl.c', 'crypto/rsa/rsa_pk1.c', 'crypto/rsa/rsa_pmeth.c', 'crypto/rsa/rsa_prn.c', 'crypto/rsa/rsa_pss.c', 'crypto/rsa/rsa_saos.c', 'crypto/rsa/rsa_sign.c', 'crypto/rsa/rsa_ssl.c', 'crypto/rsa/rsa_x931.c', 'crypto/rsa/rsa_x931g.c', 'crypto/seed/seed.c', 'crypto/seed/seed_cbc.c', 'crypto/seed/seed_cfb.c', 'crypto/seed/seed_ecb.c', 'crypto/seed/seed_ofb.c', 'crypto/sha/keccak1600.c', 'crypto/sha/sha1-mb-x86_64.s', 'crypto/sha/sha1-x86_64.s', 'crypto/sha/sha1_one.c', 'crypto/sha/sha1dgst.c', 'crypto/sha/sha256-mb-x86_64.s', 'crypto/sha/sha256-x86_64.s', 'crypto/sha/sha256.c', 'crypto/sha/sha512-x86_64.s', 'crypto/sha/sha512.c', 'crypto/siphash/siphash.c', 'crypto/siphash/siphash_ameth.c', 'crypto/siphash/siphash_pmeth.c', 'crypto/srp/srp_lib.c', 'crypto/srp/srp_vfy.c', 'crypto/stack/stack.c', 'crypto/store/loader_file.c', 'crypto/store/store_err.c', 'crypto/store/store_init.c', 'crypto/store/store_lib.c', 'crypto/store/store_register.c', 'crypto/store/store_strings.c', 'crypto/threads_none.c', 'crypto/threads_pthread.c', 'crypto/threads_win.c', 'crypto/ts/ts_asn1.c', 'crypto/ts/ts_conf.c', 'crypto/ts/ts_err.c', 'crypto/ts/ts_lib.c', 'crypto/ts/ts_req_print.c', 'crypto/ts/ts_req_utils.c', 'crypto/ts/ts_rsp_print.c', 'crypto/ts/ts_rsp_sign.c', 'crypto/ts/ts_rsp_utils.c', 'crypto/ts/ts_rsp_verify.c', 'crypto/ts/ts_verify_ctx.c', 'crypto/txt_db/txt_db.c', 'crypto/ui/ui_err.c', 'crypto/ui/ui_lib.c', 'crypto/ui/ui_null.c', 'crypto/ui/ui_openssl.c', 'crypto/ui/ui_util.c', 'crypto/uid.c', 'crypto/whrlpool/wp-x86_64.s', 'crypto/whrlpool/wp_dgst.c', 'crypto/x509/by_dir.c', 'crypto/x509/by_file.c', 'crypto/x509/t_crl.c', 'crypto/x509/t_req.c', 'crypto/x509/t_x509.c', 'crypto/x509/x509_att.c', 'crypto/x509/x509_cmp.c', 'crypto/x509/x509_d2.c', 'crypto/x509/x509_def.c', 'crypto/x509/x509_err.c', 'crypto/x509/x509_ext.c', 'crypto/x509/x509_lu.c', 'crypto/x509/x509_obj.c', 'crypto/x509/x509_r2x.c', 'crypto/x509/x509_req.c', 'crypto/x509/x509_set.c', 'crypto/x509/x509_trs.c', 'crypto/x509/x509_txt.c', 'crypto/x509/x509_v3.c', 'crypto/x509/x509_vfy.c', 'crypto/x509/x509_vpm.c', 'crypto/x509/x509cset.c', 'crypto/x509/x509name.c', 'crypto/x509/x509rset.c', 'crypto/x509/x509spki.c', 'crypto/x509/x509type.c', 'crypto/x509/x_all.c', 'crypto/x509/x_attrib.c', 'crypto/x509/x_crl.c', 'crypto/x509/x_exten.c', 'crypto/x509/x_name.c', 'crypto/x509/x_pubkey.c', 'crypto/x509/x_req.c', 'crypto/x509/x_x509.c', 'crypto/x509/x_x509a.c', 'crypto/x509v3/pcy_cache.c', 'crypto/x509v3/pcy_data.c', 'crypto/x509v3/pcy_lib.c', 'crypto/x509v3/pcy_map.c', 'crypto/x509v3/pcy_node.c', 'crypto/x509v3/pcy_tree.c', 'crypto/x509v3/v3_addr.c', 'crypto/x509v3/v3_admis.c', 'crypto/x509v3/v3_akey.c', 'crypto/x509v3/v3_akeya.c', 'crypto/x509v3/v3_alt.c', 'crypto/x509v3/v3_asid.c', 'crypto/x509v3/v3_bcons.c', 'crypto/x509v3/v3_bitst.c', 'crypto/x509v3/v3_conf.c', 'crypto/x509v3/v3_cpols.c', 'crypto/x509v3/v3_crld.c', 'crypto/x509v3/v3_enum.c', 'crypto/x509v3/v3_extku.c', 'crypto/x509v3/v3_genn.c', 'crypto/x509v3/v3_ia5.c', 'crypto/x509v3/v3_info.c', 'crypto/x509v3/v3_int.c', 'crypto/x509v3/v3_lib.c', 'crypto/x509v3/v3_ncons.c', 'crypto/x509v3/v3_pci.c', 'crypto/x509v3/v3_pcia.c', 'crypto/x509v3/v3_pcons.c', 'crypto/x509v3/v3_pku.c', 'crypto/x509v3/v3_pmaps.c', 'crypto/x509v3/v3_prn.c', 'crypto/x509v3/v3_purp.c', 'crypto/x509v3/v3_skey.c', 'crypto/x509v3/v3_sxnet.c', 'crypto/x509v3/v3_tlsf.c', 'crypto/x509v3/v3_utl.c', 'crypto/x509v3/v3err.c', 'crypto/x86_64cpuid.s'],
        hdrs = native.glob([
            'crypto/**/*.h',
            'include/**/*.h',
            'e_os.h',
        ]) + ['crypto/include/internal/bn_conf.h', 'crypto/include/internal/dso_conf.h', 'include/openssl/opensslconf.h', 'crypto/buildinf.h'],
        includes = openssl_includes,
        defines = [
            'OPENSSL_NO_STATIC_ENGINE',
        ],
        textual_hdrs = crypto_textual_hrds,
        copts = ['-DAES_ASM', '-DBSAES_ASM', '-DDSO_DLFCN', '-DECP_NISTZ256_ASM', '-DENGINESDIR="\\"/usr/local/lib/engines-1.1\\""', '-DGHASH_ASM', '-DHAVE_DLFCN_H', '-DL_ENDIAN', '-DMD5_ASM', '-DNDEBUG', '-DOPENSSLDIR="\\"/usr/local/ssl\\""', '-DOPENSSL_BN_ASM_GF2m', '-DOPENSSL_BN_ASM_MONT', '-DOPENSSL_BN_ASM_MONT5', '-DOPENSSL_IA32_SSE2', '-DOPENSSL_NO_DYNAMIC_ENGINE', '-DOPENSSL_PIC', '-DOPENSSL_THREADS', '-DOPENSSL_USE_NODELETE', '-DPADLOCK_ASM', '-DPOLY1305_ASM', '-DRC4_ASM', '-DSHA1_ASM', '-DSHA256_ASM', '-DSHA512_ASM', '-DVPAES_ASM', '-I.', '-Icrypto/include', '-Iinclude', '-Wa,--noexecstack'],
        linkopts = openssl_linkopts,
    )

    native.cc_library(
        name = 'ssl',
        visibility = [
            '//visibility:public',
        ],
        srcs = ['ssl/bio_ssl.c', 'ssl/d1_lib.c', 'ssl/d1_msg.c', 'ssl/d1_srtp.c', 'ssl/methods.c', 'ssl/packet.c', 'ssl/pqueue.c', 'ssl/record/dtls1_bitmap.c', 'ssl/record/rec_layer_d1.c', 'ssl/record/rec_layer_s3.c', 'ssl/record/ssl3_buffer.c', 'ssl/record/ssl3_record.c', 'ssl/record/ssl3_record_tls13.c', 'ssl/s3_cbc.c', 'ssl/s3_enc.c', 'ssl/s3_lib.c', 'ssl/s3_msg.c', 'ssl/ssl_asn1.c', 'ssl/ssl_cert.c', 'ssl/ssl_ciph.c', 'ssl/ssl_conf.c', 'ssl/ssl_err.c', 'ssl/ssl_init.c', 'ssl/ssl_lib.c', 'ssl/ssl_mcnf.c', 'ssl/ssl_rsa.c', 'ssl/ssl_sess.c', 'ssl/ssl_stat.c', 'ssl/ssl_txt.c', 'ssl/ssl_utst.c', 'ssl/statem/extensions.c', 'ssl/statem/extensions_clnt.c', 'ssl/statem/extensions_cust.c', 'ssl/statem/extensions_srvr.c', 'ssl/statem/statem.c', 'ssl/statem/statem_clnt.c', 'ssl/statem/statem_dtls.c', 'ssl/statem/statem_lib.c', 'ssl/statem/statem_srvr.c', 'ssl/t1_enc.c', 'ssl/t1_lib.c', 'ssl/t1_trce.c', 'ssl/tls13_enc.c', 'ssl/tls_srp.c'],
        hdrs = native.glob([
            'ssl/**/*.h',
        ]),
        includes = openssl_includes,
        copts = ['-DAES_ASM', '-DBSAES_ASM', '-DDSO_DLFCN', '-DECP_NISTZ256_ASM', '-DENGINESDIR="\\"/usr/local/lib/engines-1.1\\""', '-DGHASH_ASM', '-DHAVE_DLFCN_H', '-DL_ENDIAN', '-DMD5_ASM', '-DNDEBUG', '-DOPENSSLDIR="\\"/usr/local/ssl\\""', '-DOPENSSL_BN_ASM_GF2m', '-DOPENSSL_BN_ASM_MONT', '-DOPENSSL_BN_ASM_MONT5', '-DOPENSSL_IA32_SSE2', '-DOPENSSL_NO_DYNAMIC_ENGINE', '-DOPENSSL_PIC', '-DOPENSSL_THREADS', '-DOPENSSL_USE_NODELETE', '-DPADLOCK_ASM', '-DPOLY1305_ASM', '-DRC4_ASM', '-DSHA1_ASM', '-DSHA256_ASM', '-DSHA512_ASM', '-DVPAES_ASM', '-I.', '-Iinclude', '-Wa,--noexecstack'],
        linkopts = openssl_linkopts,
        deps = [
          ':crypto',
        ]
    )

    native.genrule(
        name = 'generate_internal_files',
        srcs = native.glob([
            # Perl modules used to generate asm files.
            #
            # The glob pattern below does not include the .pm files under the
            # external/ directory as bazel thinks those are part of some
            # external repository, complained as such:
            #       Label '//:external/perl/transfer/Text/Template.pm' crosses boundary of subpackage 'external' (perhaps you meant to put the colon here: '//external:perl/transfer/Text/Template.pm'?).
            # The workaround is to `mv external third_party`.
            '**/*.pm',
            '**/*.pl',
            '**/*.h.in',
        ]) + [
            ':configdata_pm',
        ] + crypto_textual_hrds,
        outs = ['crypto/aes/aes-x86_64.s', 'crypto/aes/aesni-mb-x86_64.s', 'crypto/aes/aesni-sha1-x86_64.s', 'crypto/aes/aesni-sha256-x86_64.s', 'crypto/aes/aesni-x86_64.s', 'crypto/aes/bsaes-x86_64.s', 'crypto/aes/vpaes-x86_64.s', 'crypto/bn/rsaz-avx2.s', 'crypto/bn/rsaz-x86_64.s', 'crypto/bn/x86_64-gf2m.s', 'crypto/bn/x86_64-mont.s', 'crypto/bn/x86_64-mont5.s', 'crypto/buildinf.h', 'crypto/camellia/cmll-x86_64.s', 'crypto/chacha/chacha-x86_64.s', 'crypto/ec/ecp_nistz256-x86_64.s', 'crypto/include/internal/bn_conf.h', 'crypto/include/internal/dso_conf.h', 'crypto/md5/md5-x86_64.s', 'crypto/modes/aesni-gcm-x86_64.s', 'crypto/modes/ghash-x86_64.s', 'crypto/poly1305/poly1305-x86_64.s', 'crypto/rc4/rc4-md5-x86_64.s', 'crypto/rc4/rc4-x86_64.s', 'crypto/sha/sha1-mb-x86_64.s', 'crypto/sha/sha1-x86_64.s', 'crypto/sha/sha256-mb-x86_64.s', 'crypto/sha/sha256-x86_64.s', 'crypto/sha/sha512-x86_64.s', 'crypto/whrlpool/wp-x86_64.s', 'crypto/x86_64cpuid.s', 'engines/e_padlock-x86_64.s', 'include/openssl/opensslconf.h'],
        cmd = ' && '.join([
            # Make the perl module files available at runtime.
            'export DIR=%s' % '/'.join(['.', PACKAGE_NAME]),
            'export PERL5LIB=$$DIR/third_party/perl:$$(dirname $(location :configdata_pm))',
        ] + ['/usr/bin/perl "$(location util/mkbuildinf.pl)" "gcc -DDSO_DLFCN -DHAVE_DLFCN_H -DNDEBUG -DOPENSSL_THREADS -DOPENSSL_NO_DYNAMIC_ENGINE -DOPENSSL_PIC -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DGHASH_ASM -DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DOPENSSLDIR=\\"\\\\\\"/usr/local/ssl\\\\\\"\\" -DENGINESDIR=\\"\\\\\\"/usr/local/lib/engines-1.1\\\\\\"\\"  -Wa,--noexecstack" linux-x86_64 > "$(location crypto/buildinf.h)"', '/usr/bin/perl -I. -Mconfigdata "$(location util/dofile.pl)" -oMakefile "$(location crypto/include/internal/bn_conf.h.in)" > "$(location crypto/include/internal/bn_conf.h)"', '/usr/bin/perl -I. -Mconfigdata "$(location util/dofile.pl)" -oMakefile "$(location crypto/include/internal/dso_conf.h.in)" > "$(location crypto/include/internal/dso_conf.h)"', '/usr/bin/perl -I. -Mconfigdata "$(location util/dofile.pl)" -oMakefile "$(location include/openssl/opensslconf.h.in)" > "$(location include/openssl/opensslconf.h)"', 'CC=gcc /usr/bin/perl "$(location crypto/aes/asm/aes-x86_64.pl)" elf "$(location crypto/aes/aes-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/aes/asm/aesni-mb-x86_64.pl)" elf "$(location crypto/aes/aesni-mb-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/aes/asm/aesni-sha1-x86_64.pl)" elf "$(location crypto/aes/aesni-sha1-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/aes/asm/aesni-sha256-x86_64.pl)" elf "$(location crypto/aes/aesni-sha256-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/aes/asm/aesni-x86_64.pl)" elf "$(location crypto/aes/aesni-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/aes/asm/bsaes-x86_64.pl)" elf "$(location crypto/aes/bsaes-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/aes/asm/vpaes-x86_64.pl)" elf "$(location crypto/aes/vpaes-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/bn/asm/rsaz-avx2.pl)" elf "$(location crypto/bn/rsaz-avx2.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/bn/asm/rsaz-x86_64.pl)" elf "$(location crypto/bn/rsaz-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/bn/asm/x86_64-gf2m.pl)" elf "$(location crypto/bn/x86_64-gf2m.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/bn/asm/x86_64-mont.pl)" elf "$(location crypto/bn/x86_64-mont.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/bn/asm/x86_64-mont5.pl)" elf "$(location crypto/bn/x86_64-mont5.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/camellia/asm/cmll-x86_64.pl)" elf "$(location crypto/camellia/cmll-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/chacha/asm/chacha-x86_64.pl)" elf "$(location crypto/chacha/chacha-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/ec/asm/ecp_nistz256-x86_64.pl)" elf "$(location crypto/ec/ecp_nistz256-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/md5/asm/md5-x86_64.pl)" elf "$(location crypto/md5/md5-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/modes/asm/aesni-gcm-x86_64.pl)" elf "$(location crypto/modes/aesni-gcm-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/modes/asm/ghash-x86_64.pl)" elf "$(location crypto/modes/ghash-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/poly1305/asm/poly1305-x86_64.pl)" elf "$(location crypto/poly1305/poly1305-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/rc4/asm/rc4-md5-x86_64.pl)" elf "$(location crypto/rc4/rc4-md5-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/rc4/asm/rc4-x86_64.pl)" elf "$(location crypto/rc4/rc4-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/sha/asm/sha1-mb-x86_64.pl)" elf "$(location crypto/sha/sha1-mb-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/sha/asm/sha1-x86_64.pl)" elf "$(location crypto/sha/sha1-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/sha/asm/sha256-mb-x86_64.pl)" elf "$(location crypto/sha/sha256-mb-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/sha/asm/sha512-x86_64.pl)" elf "$(location crypto/sha/sha256-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/sha/asm/sha512-x86_64.pl)" elf "$(location crypto/sha/sha512-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/whrlpool/asm/wp-x86_64.pl)" elf "$(location crypto/whrlpool/wp-x86_64.s)"', 'CC=gcc /usr/bin/perl "$(location crypto/x86_64cpuid.pl)" elf "$(location crypto/x86_64cpuid.s)"', 'CC=gcc /usr/bin/perl "$(location engines/asm/e_padlock-x86_64.pl)" elf "$(location engines/e_padlock-x86_64.s)"']),
    )

    native.genrule(
        name = 'configdata_pm',
        srcs = native.glob([
            '**/*.pm',
            # The 10-main.conf is the database storing the combinationas of
            # platforms compilers supported by openssl.
            'Configurations/**',
            # The existence of the following directories under crypto/ is used
            # to populate the correct set of configuration options:
            #       aes aria bf camellia cast des dh dsa ec hmac idea md2 md5
            #       mdc2 rc2 rc4 rc5 ripemd rsa seed sha
            'crypto/**',
            # The various build.info files are used to populate the
            # %unified_info section in the generated configdata.pm file.
            '**/build.info',
        ]) + [
            'Configure',
            'config',
            # The opensslv.h file contains version information and is used by
            # config.
            'include/openssl/opensslv.h',
            'util/dofile.pl',
        ],
        outs = [
            # This perl module is used to generate other .h and .s files.
            'configdata.pm',
        ],
        cmd = ' && '.join([
            'export DIR=%s' % '/'.join(['.', PACKAGE_NAME]),
            'export PERL5LIB=$$DIR/util:$$DIR/third_party/perl:$(@D)',
            '$(location config) &> /dev/null',
            'rm -f $@',
            'cp -L configdata.pm $(@D)',
        ]),
    )

    native.cc_binary(
        name = 'openssl',
        visibility = [
            '//visibility:public',
        ],
        srcs = native.glob([
            'apps/*.c',
            'apps/*.h',
        ], exclude=[
            'apps/win32_init.c',
        ]) + [
            ':progs_h',
        ],
        deps = [
            ':ssl',
        ],
        copts = [
            # The generated progs.h file resides in the $GENDIR
            '-I$(GENDIR)/%s' % PACKAGE_NAME,
        ] + ['-DAES_ASM', '-DBSAES_ASM', '-DDSO_DLFCN', '-DECP_NISTZ256_ASM', '-DENGINESDIR="\\"/usr/local/lib/engines-1.1\\""', '-DGHASH_ASM', '-DHAVE_DLFCN_H', '-DL_ENDIAN', '-DMD5_ASM', '-DNDEBUG', '-DOPENSSLDIR="\\"/usr/local/ssl\\""', '-DOPENSSL_BN_ASM_GF2m', '-DOPENSSL_BN_ASM_MONT', '-DOPENSSL_BN_ASM_MONT5', '-DOPENSSL_IA32_SSE2', '-DOPENSSL_NO_DYNAMIC_ENGINE', '-DOPENSSL_PIC', '-DOPENSSL_THREADS', '-DOPENSSL_USE_NODELETE', '-DPADLOCK_ASM', '-DPOLY1305_ASM', '-DRC4_ASM', '-DSHA1_ASM', '-DSHA256_ASM', '-DSHA512_ASM', '-DVPAES_ASM', '-I.', '-Icrypto/include', '-Iinclude', '-Wa,--noexecstack'],
        linkopts = [
            '-ldl',
        ],
    )

    native.genrule(
        name = 'progs_h',
        srcs = native.glob([
            'apps/*.c',
        ]) + [
            'apps/progs.pl',
            ':configdata_pm',
        ],
        outs = [
            'progs.h',
        ],
        cmd = ' && '.join([
            # The python3 -c '...' hack emulates the GNU `readlink -f`, which is
            # absent from BSD based distributions.
            r'''export DIR=$$(python3 -c 'import os; print(os.path.realpath("%s"))') ''' % '/'.join(['.', PACKAGE_NAME]),
            r'''export PERL5LIB=$$DIR:$$DIR/third_party/perl:$$(python3 -c 'import os; print(os.path.realpath("$(@D)"))') ''',
            'pushd $$DIR',
                # This perl script must be invoked using exactly this format.
                # Otherwise, it will fail to scan the apps/openssl directory and
                # miss out the `extern int` declarations in the generated
                # progs.h file.
                'perl apps/progs.pl apps/openssl > tmp',
            'popd',
            'mv $$DIR/tmp $@',
        ]),
    )
