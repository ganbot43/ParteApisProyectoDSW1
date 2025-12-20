using apiModeloExamen.Contracts.Entities;
using apiModeloExamen.Repositories.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace apiModeloExamen.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CategoriasController : ControllerBase
    {
        private readonly ICategoriaRepository _repo;

        public CategoriasController(ICategoriaRepository repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public async Task<IActionResult> Listar()
        {
            var categorias = await _repo.ListarAsync();
            return Ok(categorias);
        }

        [HttpPost]
        public async Task<IActionResult> Insertar([FromBody] Categoria categoria)
        {
            var id = await _repo.InsertarAsync(categoria);
            return Ok(id);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Editar(int id, [FromBody] Categoria categoria)
        {
            categoria.IdCategoria = id;
            await _repo.EditarAsync(categoria);
            return NoContent();
        }
    }
}