using apiModeloExamen.Contracts.Entities;
using apiModeloExamen.Repositories.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace apiModeloExamen.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductosController : ControllerBase
    {
        private readonly IProductoRepository _repo;
        public ProductosController(IProductoRepository repo) => _repo = repo;

        [HttpGet]
        public async Task<IActionResult> Listar() => Ok(await _repo.ListarAsync());

        [HttpGet("por-categoria/{idCategoria}")]
        public async Task<IActionResult> ListarPorCategoria(int idCategoria) =>
            Ok(await _repo.ListarPorCategoriaAsync(idCategoria));

        [HttpPost]
        public async Task<IActionResult> Insertar([FromBody] Producto producto)
        {
            var id = await _repo.InsertarAsync(producto);
            return Ok(id);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Editar(int id, [FromBody] Producto producto)
        {
            producto.IdProducto = id;
            await _repo.EditarAsync(producto);
            return NoContent();
        }
    }
}