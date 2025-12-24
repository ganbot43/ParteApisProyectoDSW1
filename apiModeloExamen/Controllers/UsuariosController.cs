using apiModeloExamen.Contracts.Dtos;
using apiModeloExamen.Repositories;
using Microsoft.AspNetCore.Mvc;


namespace apiModeloExamen.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuariosController : ControllerBase
    {
        private readonly IUsuarioRepository _repo;

        public UsuariosController(IUsuarioRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public async Task<IActionResult> Listar()
        {
            var usuarios = await _repo.ListarAsync();
            return Ok(usuarios);
        }

        [HttpPost]
        public async Task<IActionResult> Insertar([FromBody] UsuarioLoginDto usuario)
        {
            var id = await _repo.InsertarAsync(usuario);
            return Ok(id);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Editar(int id, [FromBody] UsuarioLoginDto usuario)
        {
            usuario.IdUsuario = id;
            await _repo.EditarAsync(usuario);
            return NoContent();
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto login)
        {
            var usuario = await _repo.LoginAsync(login.Email, login.PasswordHash);

            if (usuario == null)
                return Unauthorized(new { mensaje = "Email o contraseña incorrectos" });

            return Ok(new
            {
                mensaje = "Login exitoso",
                usuario
            });
        }
    }
}